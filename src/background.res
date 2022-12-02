open Promise
open Utils
open Common
open Common.Idb
open Database

let dbInstance = getDB()

Chrome.addMessageListener((message, sender, sendResponse) => {
  let mType = message._type
  let mText = message.text
  let tab = sender["tab"]

  switch mType {
  | TRASTALTE =>
    adapterTrans(mText)->then(ret => {
      // https://forum.rescript-lang.org/t/modeling-polymorphic-callback/3129
      sendResponse(. Obj.magic(ret))
      resolve()
    })
  | FAVORITE(GET) =>
    dbInstance->then(db => {
      getDBValueFromIndex(~db, ~storeName="favorite", ~indexName="text", ~key=mText)->then(
        ret => {
          if !ret {
            sendResponse(. Obj.magic(false))
          } else {
            sendResponse(. Obj.magic(true))
          }
          resolve()
        },
      )
    })
  | FAVORITE(ADD) =>
    dbInstance->then(db => {
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
      resolve()
    })

  | FAVORITE(DELETE) =>
    dbInstance->then(db => {
      getDBKeyFromIndex(~db, ~storeName="favorite", ~indexName="text", ~key=mText)
      ->then(
        key => {
          deleteDBValue(~db, ~storeName="favorite", ~key)->ignore
          sendResponse(. Obj.magic(false))
          resolve()
        },
      )
      ->ignore

      resolve()
    })
  | HISTORY(ADD) =>
    dbInstance->then(db => {
      getDBValueFromIndex(~db, ~storeName="history", ~indexName="text", ~key=mText)->then(
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
          resolve()
        },
      )
    })
  | _ => Promise.resolve()
  }->ignore

  // async operation must return `true`
  true
})
