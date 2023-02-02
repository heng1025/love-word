open Utils
open Common
open Common.Idb
open Database

let dbInstance = getDB()

let messageHandler = async (message, sender, sendResponse) => {
  let mType = message._type
  let mText = switch message.text {
  | Some(v) => v
  | _ => ""
  }

  let tab = switch sender["tab"] {
  | Some(v) => v
  | _ => {
      "url": sender["url"],
      "title": "Love Word",
      "favIconUrl": `${sender["origin"]}/icons/lw32x32.png`,
    }
  }

  // https://forum.rescript-lang.org/t/modeling-polymorphic-callback/3129 (Obj.magic)
  switch mType {
  | TRASTALTE => {
      let ret = await adapterTrans(mText)
      sendResponse(. ret)
    }

  | Message(FAVORITE, GET) => {
      let db = await dbInstance
      let ret = await getDBValueFromIndex(~db, ~storeName="favorite", ~indexName="text", ~key=mText)
      sendResponse(. Obj.magic(!(!ret)))
    }

  | Message(FAVORITE, GETALL) => {
      let db = await dbInstance
      let ret = await getDBAllValueFromIndex(~db, ~storeName="favorite", ~indexName="text")
      sendResponse(. ret)
    }

  | Message(FAVORITE, ADD) => {
      let db = await dbInstance
      await addDBValue(
        ~db,
        ~storeName="favorite",
        ~data={
          "date": Js.Date.now(),
          "text": mText,
          "trans": message.trans,
          "url": tab["url"],
          "title": tab["title"],
          "favIconUrl": tab["favIconUrl"],
        },
        (),
      )
      sendResponse(. Obj.magic(true))
    }

  | Message(FAVORITE, DELETE) => {
      let db = await dbInstance
      // delete record according by date
      switch message.date {
      | Some(v) => {
          let tx = createTransaction(~db, ~storeName="favorite", ~mode="readwrite", ())
          let pstores = Js.Array2.map(v, item => {
            tx.store.delete(. Obj.magic(item))
          })
          let _ = await Js.Promise2.all(pstores)
          sendResponse(. Obj.magic(false))
        }

      | _ =>
        // delete one text
        let key = await getDBKeyFromIndex(~db, ~storeName="favorite", ~indexName="text", ~key=mText)
        let _ = await deleteDBValue(~db, ~storeName="favorite", ~key)
        sendResponse(. Obj.magic(false))
      }
    }

  | Message(FAVORITE, CLEAR) => {
      let db = await dbInstance
      let _ = await clearDBValue(~db, ~storeName="favorite")
      sendResponse(. Obj.magic(None))
    }

  | Message(HISTORY, ADD) => {
      let db = await dbInstance
      let ret = await getDBValueFromIndex(~db, ~storeName="history", ~indexName="text", ~key=mText)
      let _ = switch !ret {
      | true =>
        await addDBValue(
          ~db,
          ~storeName="history",
          ~data={
            "date": Js.Date.now(),
            "text": mText,
            "url": tab["url"],
            "title": tab["title"],
            "favIconUrl": tab["favIconUrl"],
          },
          (),
        )

      | _ => ()
      }
    }

  | Message(HISTORY, DELETE) => {
      let db = await dbInstance
      switch message.date {
      | Some(v) => {
          let tx = createTransaction(~db, ~storeName="history", ~mode="readwrite", ())
          let pstores = Js.Array2.map(v, item => {
            tx.store.delete(. Obj.magic(item))
          })
          let _ = await Js.Promise2.all(pstores)
        }

      | _ => ()
      }
      sendResponse(. Obj.magic(None))
    }

  | Message(HISTORY, CLEAR) => {
      let db = await dbInstance
      await clearDBValue(~db, ~storeName="history")
    }

  | Message(HISTORY, GETALL) => {
      let db = await dbInstance
      let ret = await getDBAllValueFromIndex(~db, ~storeName="history", ~indexName="date")
      sendResponse(. ret)
    }

  | _ => ()
  }
}

Chrome.addMessageListener((message, sender, sendResponse) => {
  messageHandler(message, sender, sendResponse)->ignore

  // async operation must return `true`
  true
})
