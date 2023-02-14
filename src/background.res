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
  sendResponse(. ret)
}

let favGetOneMessageHandler = async (msg: textMsgContent, sendResponse) => {
  let db = await dbInstance
  let ret = await getDBValueFromIndex(~db, ~storeName="favorite", ~indexName="text", ~key=msg.text)
  sendResponse(. Obj.magic(!(!ret)))
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
    trans: msg.trans,
  }
  await addDBValue(~db, ~storeName="favorite", ~data, ())
  sendResponse(. Obj.magic(true))
}
// fav cancel
let favDeleteOneMessageHandler = async (msg: textMsgContent, sendResponse) => {
  let db = await dbInstance
  // delete one text
  let key = await getDBKeyFromIndex(~db, ~storeName="favorite", ~indexName="text", ~key=msg.text)
  let _ = await deleteDBValue(~db, ~storeName="favorite", ~key)
  sendResponse(. Obj.magic(false))
}

let recordDeleteManyMessageHandler = async (recordType, msg: datesMsgContent, sendResponse) => {
  let db = await dbInstance
  let tx = createTransaction(~db, ~storeName=recordType, ~mode="readwrite", ())
  let pstores = Js.Array2.map(msg.dates, item => {
    tx.store.delete(. Obj.magic(item))
  })
  let _ = await Js.Promise2.all(pstores)
  sendResponse(. Obj.magic(false))
}

// GetAll / Clear
let recordMessageHandler = async (recordType, extraAction, sendResponse) => {
  switch extraAction {
  | GetAll => {
      let db = await dbInstance
      let ret = await getDBAllValueFromIndex(~db, ~storeName=recordType, ~indexName="text")
      sendResponse(. ret)
    }

  | Clear =>
    {
      let db = await dbInstance
      let _ = await clearDBValue(~db, ~storeName=recordType)
    }

    sendResponse(. Obj.magic(None))
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
  let ret: bool = await getDBValueFromIndex(
    ~db,
    ~storeName="history",
    ~indexName="text",
    ~key=mText,
  )
  let _ = switch !ret {
  | true => await addDBValue(~db, ~storeName="history", ~data, ())
  | _ => ()
  }
  sendResponse(. Obj.magic(None))
}

Chrome.addMessageListener((message: msgContent, sender, sendResponse) => {
  // must invoke `sendRespone`, or message channel will close in advance
  switch message {
  | TranslateMsgContent(msg) => translateMessageHandler(msg, sendResponse)
  // favorite
  | FavGetOneMsgContent(msg) => favGetOneMessageHandler(msg, sendResponse)
  | FavAddMsgContent(msg) => favAddMessageHandler(msg, sender, sendResponse)
  | FavDeleteOneMsgContent(msg) => favDeleteOneMessageHandler(msg, sendResponse)
  | FavDeleteManyMsgContent(msg) => recordDeleteManyMessageHandler("favorite", msg, sendResponse)
  | FavExtraMsgContent(msg) => recordMessageHandler("favorite", msg, sendResponse)
  // history
  | HistoryAddMsgContent(msg) => historyAddMessageHandler(msg, sender, sendResponse)
  | HistoryDeleteManyMsgContent(msg) => recordDeleteManyMessageHandler("history", msg, sendResponse)
  | HistoryExtraMsgContent(msg) => recordMessageHandler("history", msg, sendResponse)
  }->ignore

  // async operation must return `true`
  true
})
