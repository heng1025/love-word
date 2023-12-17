open Common.Idb
open Utils

let createStoreWithIndex = (db, storeName: recordType) => {
  let favoriteStore = createObjectStore(~db, ~storeName, ~options={keyPath: "date"})
  createIndex(~objStore=favoriteStore, ~indexName="date", ~keyPath="date")
  createIndex(~objStore=favoriteStore, ~indexName="text", ~keyPath="text")
}

let getDB = async () => {
  await openDB(
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
