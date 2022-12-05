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
  let tab = sender["tab"]

  switch mType {
  | TRASTALTE =>
    adapterTrans(mText)->then(ret => {
      // https://forum.rescript-lang.org/t/modeling-polymorphic-callback/3129
      sendResponse(. ret)
      resolve()
    })
  | FAVORITE(GET) =>
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
  | FAVORITE(GETALL) =>
    dbInstance->then(db => {
      getDBAllValueFromIndex(~db, ~storeName="favorite", ~indexName="text")->thenResolve(
        ret => {
          sendResponse(. ret)
        },
      )
    })
  | FAVORITE(ADD) =>
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
  | FAVORITE(DELETE) =>
    dbInstance->thenResolve(db => {
      getDBKeyFromIndex(~db, ~storeName="favorite", ~indexName="text", ~key=mText)
      ->thenResolve(
        key => {
          deleteDBValue(~db, ~storeName="favorite", ~key)->ignore
          sendResponse(. Obj.magic(false))
        },
      )
      ->ignore
    })
  | HISTORY(ADD) =>
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
  | HISTORY(DELETE) =>
    dbInstance->thenResolve(db => {
      switch message.date {
      | Some(v) =>
        Js.Array2.forEach(
          v,
          item => {
            deleteDBValue(~db, ~storeName="history", ~key=item)->ignore
          },
        )
        sendResponse(. Obj.magic(None))
      | _ => ()
      }
    })
  | HISTORY(CLEAR) =>
    dbInstance->thenResolve(db => {
      clearDBValue(~db, ~storeName="history")
      ->thenResolve(
        _ => {
          sendResponse(. Obj.magic(None))
        },
      )
      ->ignore
    })
  | HISTORY(GETALL) =>
    dbInstance->then(db => {
      getDBAllValueFromIndex(~db, ~storeName="history", ~indexName="text")->thenResolve(
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
