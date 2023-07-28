open Common
open Utils

let createStoreWithIndex = (db, storeName: recordType) => {
  let favoriteStore = Idb.createObjectStore(~db, ~storeName, ~options={keyPath: "date"})
  Idb.createIndex(~objStore=favoriteStore, ~indexName="date", ~keyPath="date")
  Idb.createIndex(~objStore=favoriteStore, ~indexName="text", ~keyPath="text")
}

let getDB = () => {
  Idb.openDB(
    ~name="loveWord",
    ~options={
      upgrade: db => {
        createStoreWithIndex(db, Favorite)
        createStoreWithIndex(db, History)
      },
    },
    (),
  )
}
