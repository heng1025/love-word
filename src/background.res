open Promise
open Utils
open Common
open Common.Idb
open Database

let dbInstance = getDB()

Chrome.addMessageListener((message, sender, sendResponse) => {
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

  switch mType {
  | TRASTALTE =>
    adapterTrans(mText)->then(ret => {
      // https://forum.rescript-lang.org/t/modeling-polymorphic-callback/3129
      sendResponse(. ret)
      resolve()
    })
  | Message(FAVORITE, GET) =>
    dbInstance->then(db => {
      getDBValueFromIndex(~db, ~storeName="favorite", ~indexName="text", ~key=mText)->thenResolve(
        ret => {
          if !ret {
            sendResponse(. Obj.magic(false))
          } else {
            sendResponse(. Obj.magic(true))
          }
        },
      )
    })
  | Message(FAVORITE, GETALL) =>
    dbInstance->then(db => {
      getDBAllValueFromIndex(~db, ~storeName="favorite", ~indexName="text")->thenResolve(
        ret => {
          sendResponse(. ret)
        },
      )
    })
  | Message(FAVORITE, ADD) =>
    dbInstance->thenResolve(db => {
      addDBValue(
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
      )->ignore
      sendResponse(. Obj.magic(true))
    })
  | Message(FAVORITE, DELETE) =>
    dbInstance->thenResolve(db => {
      // delete record according by date
      switch message.date {
      | Some(v) => {
          let tx = createTransaction(~db, ~storeName="favorite", ~mode="readwrite", ())
          let pstores = Js.Array2.map(
            v,
            item => {
              tx.store.delete(. Obj.magic(item))
            },
          )
          all(pstores)
          ->thenResolve(
            _ => {
              sendResponse(. Obj.magic(false))
            },
          )
          ->ignore
        }

      | _ =>
        // delete one text
        getDBKeyFromIndex(~db, ~storeName="favorite", ~indexName="text", ~key=mText)
        ->thenResolve(
          key => {
            deleteDBValue(~db, ~storeName="favorite", ~key)->ignore
            sendResponse(. Obj.magic(false))
          },
        )
        ->ignore
      }
    })
  | Message(FAVORITE, CLEAR) =>
    dbInstance->thenResolve(db => {
      clearDBValue(~db, ~storeName="favorite")
      ->thenResolve(
        _ => {
          sendResponse(. Obj.magic(None))
        },
      )
      ->ignore
    })
  | Message(HISTORY, ADD) =>
    dbInstance->then(db => {
      getDBValueFromIndex(~db, ~storeName="history", ~indexName="text", ~key=mText)->thenResolve(
        ret => {
          if !ret {
            addDBValue(
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
            )->ignore
          }
        },
      )
    })
  | Message(HISTORY, DELETE) =>
    dbInstance->thenResolve(db => {
      switch message.date {
      | Some(v) => {
          let tx = createTransaction(~db, ~storeName="history", ~mode="readwrite", ())
          let pstores = Js.Array2.map(
            v,
            item => {
              tx.store.delete(. Obj.magic(item))
            },
          )
          all(pstores)
          ->thenResolve(
            _ => {
              sendResponse(. Obj.magic(None))
            },
          )
          ->ignore
        }

      | _ => ()
      }
    })
  | Message(HISTORY, CLEAR) =>
    dbInstance->thenResolve(db => {
      clearDBValue(~db, ~storeName="history")
      ->thenResolve(
        _ => {
          sendResponse(. Obj.magic(None))
        },
      )
      ->ignore
    })
  | Message(HISTORY, GETALL) =>
    dbInstance->then(db => {
      getDBAllValueFromIndex(~db, ~storeName="history", ~indexName="date")->thenResolve(
        ret => {
          sendResponse(. ret)
        },
      )
    })
  | _ => Promise.resolve()
  }->ignore

  // async operation must return `true`
  true
})
