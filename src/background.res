open Promise
open Utils
open Common
open Common.Chrome
open Common.Idb
open Database

let dbInstance = getDB()

Chrome.addMessageListener((message, _, sendResponse) => {
  let mType = message["type"]
  let mVal = message["value"]
  switch mType {
  | TRASTALTE =>
    adapterTrans(mVal)->then(ret => {
      // https://forum.rescript-lang.org/t/modeling-polymorphic-callback/3129
      sendResponse(. Obj.magic(ret))
      resolve()
    })
  | FAVORITE(GET) =>
    dbInstance->then(db => {
      getDBValueFromIndex(~db, ~storeName="favorite", ~indexName="text", ~key=mVal)->then(
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
          "text": mVal,
        },
        (),
      )->ignore
      sendResponse(. Obj.magic(true))
      resolve()
    })

  | FAVORITE(DELETE) =>
    dbInstance->then(db => {
      getDBKeyFromIndex(~db, ~storeName="favorite", ~indexName="text", ~key=mVal)
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
      getDBValueFromIndex(~db, ~storeName="history", ~indexName="date", ~key=mVal)->then(
        ret => {
          if !ret {
            addDBValue(
              ~db,
              ~storeName="history",
              ~data={
                "date": Js.Date.now(),
                "text": mVal,
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
