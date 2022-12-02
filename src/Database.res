open Common

let getDB = () => {
  Idb.openDB(
    ~name="loveWord",
    ~options={
      upgrade: db => {
        let favoriteStore = Idb.createObjectStore(
          ~db,
          ~storeName="favorite",
          ~options={keyPath: "date"},
        )
        Idb.createIndex(~objStore=favoriteStore, ~indexName="date", ~keyPath="date")
        Idb.createIndex(~objStore=favoriteStore, ~indexName="text", ~keyPath="text")

        let historyStore = Idb.createObjectStore(
          ~db,
          ~storeName="history",
          ~options={keyPath: "date"},
        )

        Idb.createIndex(~objStore=historyStore, ~indexName="date", ~keyPath="date")
      },
    },
    (),
  )
}
