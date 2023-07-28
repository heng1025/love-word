open Utils
open Common
open Common.Idb
open Database

let getBrowserTab = sender => {
  switch sender["tab"] {
  | Some(v) => v
  | _ => {
      "url": sender["url"],
      "title": "Love Word",
      "favIconUrl": `${sender["origin"]}/icons/lw32x32.png`,
    }
  }
}

let dbInstance = getDB()

let translateMessageHandler = async (msg: textMsgContent, sendResponse) => {
  let ret = await adapterTrans(msg.text)
  sendResponse(ret)
}

let favGetOneMessageHandler = async (msg: textMsgContent, sendResponse) => {
  let db = await dbInstance
  let ret = await getDBValueFromIndex(~db, ~storeName=Favorite, ~indexName="text", ~key=msg.text)
  sendResponse(Obj.magic(!(!ret)))
}

// add fav
let favAddMessageHandler = async (msg: favAddMsgContent, sender, sendResponse) => {
  let db = await dbInstance
  let tab = getBrowserTab(sender)
  let data = {
    url: tab["url"],
    title: tab["title"],
    favIconUrl: tab["favIconUrl"],
    date: Js.Date.now(),
    text: msg.text,
    translation: msg.translation,
  }
  // local
  await addDBValue(~db, ~storeName=Favorite, ~data, ())
  // server
  let _ = await recordRemoteAction(~recordType=Favorite, ~data, ~method="post")
  sendResponse(Obj.magic(true))
}
// fav cancel
let favDeleteOneMessageHandler = async (msg: textMsgContent, sendResponse) => {
  let db = await dbInstance
  // delete one text
  let key = await getDBKeyFromIndex(~db, ~storeName=Favorite, ~indexName="text", ~key=msg.text)
  // local
  let _ = await deleteDBValue(~db, ~storeName=Favorite, ~key)
  // server
  let _ = await recordRemoteAction(~recordType=Favorite, ~data={"text": msg.text}, ~method="delete")
  sendResponse(Obj.magic(false))
}

let recordDeleteManyMessageHandler = async (
  recordType: recordType,
  msg: recordsMsgContent,
  sendResponse,
) => {
  let db = await dbInstance
  let tx = createTransaction(~db, ~storeName=recordType, ~mode="readwrite", ())
  let pstores = Js.Array2.map(msg.records, item => {
    tx.store.delete(Obj.magic(item.date))
  })
  // local
  let _ = await Js.Promise2.all(pstores)
  // server
  let _ = await recordRemoteAction(
    ~recordType,
    ~data={"text": Js.Array2.map(msg.records, v => v.text)},
    ~method="delete",
  )
  sendResponse(Obj.magic(false))
}

// GetAll / Clear
let recordMessageHandler = async (recordType: recordType, extraAction, sendResponse) => {
  switch extraAction {
  | GetAll => {
      let db = await dbInstance
      // local
      let retFromLocals = await getDBAllValueFromIndex(
        ~db,
        ~storeName=recordType,
        ~indexName="text",
      )
      // server
      let retFromServers = switch await recordRemoteAction(~recordType) {
      | Ok(val) => val
      | Error(_) => []
      }
      let concatLocalWithRemote = (acc, local) => {
        local["sync"] = false
        Js.Array2.forEach(retFromServers, remote => {
          let isTextExisted = local["text"] === remote["text"]
          if isTextExisted {
            local["sync"] = true
          } else {
            remote["sync"] = true
            if Js.Array2.every(acc, v => v["text"] !== remote["text"]) {
              let _ = Js.Array2.push(acc, remote)
            }
          }
        })

        if Js.Array2.every(acc, v => v["text"] !== local["text"]) {
          let _ = Js.Array2.push(acc, local)
        }
        acc
      }
      // strategy: local first
      let tranverseLocals = ref(retFromLocals)
      if Js.Array2.length(retFromLocals) === 0 {
        tranverseLocals := retFromServers
      }
      let ret = Js.Array2.reduce(tranverseLocals.contents, concatLocalWithRemote, [])
      sendResponse(Obj.magic(ret))
    }

  | Clear =>
    {
      let db = await dbInstance
      let _ = await clearDBValue(~db, ~storeName=recordType)
    }

    sendResponse(Obj.magic(None))
  }
}

let historyAddMessageHandler = async (msg: textMsgContent, sender, sendResponse) => {
  let db = await dbInstance
  let mText = msg.text
  let tab = getBrowserTab(sender)
  let data: recordData = {
    url: tab["url"],
    title: tab["title"],
    favIconUrl: tab["favIconUrl"],
    date: Js.Date.now(),
    text: mText,
  }
  let ret: bool = await getDBValueFromIndex(~db, ~storeName=History, ~indexName="text", ~key=mText)
  let _ = switch !ret {
  | true => {
      // local
      await addDBValue(~db, ~storeName=History, ~data, ())
      // server
      let _ = await recordRemoteAction(~recordType=History, ~data)
    }
  | _ => ()
  }
  sendResponse(Obj.magic(None))
}

Chrome.addMessageListener((message: msgContent, sender, sendResponse) => {
  // must invoke `sendRespone`, or message channel will close in advance
  switch message {
  | TranslateMsgContent(msg) => translateMessageHandler(msg, sendResponse)
  // favorite
  | FavGetOneMsgContent(msg) => favGetOneMessageHandler(msg, sendResponse)
  | FavAddMsgContent(msg) => favAddMessageHandler(msg, sender, sendResponse)
  | FavDeleteOneMsgContent(msg) => favDeleteOneMessageHandler(msg, sendResponse)
  | FavDeleteManyMsgContent(msg) => recordDeleteManyMessageHandler(Favorite, msg, sendResponse)
  | FavExtraMsgContent(msg) => recordMessageHandler(Favorite, msg, sendResponse)
  // history
  | HistoryAddMsgContent(msg) => historyAddMessageHandler(msg, sender, sendResponse)
  | HistoryDeleteManyMsgContent(msg) => recordDeleteManyMessageHandler(History, msg, sendResponse)
  | HistoryExtraMsgContent(msg) => recordMessageHandler(History, msg, sendResponse)
  }->ignore

  // async operation must return `true`
  true
})
