module Webapi = {
  module Element = {
    @get external style: Dom.element => Js.Dict.t<string> = "style"
    @send external text: (Dom.element, string) => string = "text"
    @send external contains: (Js.Nullable.t<Dom.element>, Dom.element) => bool = "contains"
    @send external focus: Dom.element => unit = "focus"
    @send external play: Dom.element => unit = "play"
    @send external pause: Dom.element => unit = "pause"
    @get external getAudioSrc: Dom.element => string = "src"
    @set external createAudioSrc: (Dom.element, string) => unit = "src"
    @send external attachShadow: (Js.Nullable.t<Dom.element>, 'a) => Dom.element = "attachShadow"
    @send external appendChild: (Dom.element, Js.Nullable.t<Dom.element>) => unit = "appendChild"
    @send
    external setAttribute: (Js.Nullable.t<Dom.element>, string, string) => unit = "setAttribute"
  }

  module Document = {
    type t

    @val external document: t = "document"
    @get external body: t => Dom.element = "body"
    @get external documentElement: t => Dom.element = "documentElement"
    @send external createElement: (t, string) => Js.Nullable.t<Dom.element> = "createElement"
  }

  module MouseEvent = {
    type t = {
      pageX: int,
      pageY: int,
      offsetX: int,
      offsetY: int,
      clientX: int,
      clientY: int,
      altKey: bool,
      ctrlKey: bool,
      shiftKey: bool,
      target: Dom.element,
      stopPropagation: @uncurry (. unit) => unit,
    }
  }

  module KeyboardEvent = {
    type t = {
      keyCode: int,
      altKey: bool,
      ctrlKey: bool,
      shiftKey: bool,
      target: Dom.element,
    }
  }

  module Window = {
    type selection
    type selectionRange
    type domRect = {
      bottom: float,
      height: float,
      left: float,
      right: float,
      top: float,
      width: float,
      x: float,
      y: float,
    }
    @scope("window") @val
    external windowInnerWidth: int = "innerWidth"
    @scope("window") @val
    external scrollY: int = "scrollY"
    @scope("window") @val
    external scrollX: int = "scrollX"
    @scope("window") @val
    external getSelection: unit => selection = "getSelection"
    @get
    external rangeCount: selection => int = "rangeCount"
    @send
    external getRangeAt: (selection, int) => selectionRange = "getRangeAt"
    @send
    external selectionToString: selection => string = "toString"
    @send
    external rangeToString: selectionRange => string = "toString"
    @send
    external getBoundingClientRect: selectionRange => domRect = "getBoundingClientRect"

    type audio
    @new
    external createAudio: (~url: string=?, unit) => Js.null<audio> = "Audio"
    @set
    external setAudioSrc: (audio, string) => unit = "src"
    @set
    external onEnded: (audio, @uncurry ('e => unit)) => unit = "onended"
    @send
    external playAudio: audio => unit = "play"
    @scope("window") @val
    external addMouseEventListener: (string, @uncurry (MouseEvent.t => unit)) => unit =
      "addEventListener"
    @scope("window") @val
    external removeMouseEventListener: (string, @uncurry (MouseEvent.t => unit)) => unit =
      "removeEventListener"
    @scope("window") @val
    external addKeyboardEventListener: (string, @uncurry (KeyboardEvent.t => unit)) => unit =
      "addEventListener"
    @scope("window") @val
    external removeKeyboardEventListener: (string, @uncurry (KeyboardEvent.t => unit)) => unit =
      "removeEventListener"

    type init<'body> = {
      method?: string,
      mode?: string,
      body?: 'body,
    }
    module Response = {
      type t<'data>
      @send external json: t<'data> => promise<'data> = "json"
    }

    @val
    external fetch: (~input: string, ~init: init<int>=?, unit) => promise<Response.t<'result>> =
      "fetch"
  }
}

module Chrome = {
  @scope(("chrome", "runtime")) @val
  external getURL: string => string = "getURL"
  @scope(("chrome", "runtime")) @val
  external sendMessage: 'message => promise<'ret> = "sendMessage"
  @scope(("chrome", "runtime", "onMessage")) @val
  external addMessageListener: (@uncurry ('message, 'sender, (. 'params) => unit) => bool) => unit =
    "addListener"

  @scope(("chrome", "storage", "onChanged")) @val
  external addStorageListener: (@uncurry ('changes, 'areaName) => unit) => unit = "addListener"
  @scope(("chrome", "storage", "local")) @val
  external getExtStorage: (~keys: 'keys=?) => promise<'obj> = "get"
  @scope(("chrome", "storage", "local")) @val
  external setExtStorage: (~items: 'items) => promise<unit> = "set"
  @scope(("chrome", "storage", "local")) @val
  external removeExtStorage: (~keys: 'keys=?) => promise<unit> = "remove"
}

module Md5 = {
  @module("md5") external createMd5: string => string = "default"
}
module Qs = {
  @module("qs") external stringify: 'a => string = "stringify"
}

module FrancMin = {
  type options = {minLength: int, only: Js.Array2.t<string>}
  @module("franc-min") external createFranc: (string, options) => string = "franc"
}

module Idb = {
  type db
  type wrappedDB
  type unWrappedDB

  type objStoreOptions = {
    keyPath?: string,
    autoIncrement?: bool,
  }
  type data
  type cursor
  type rec objStore = {
    add: (. data) => promise<unit>,
    delete: (. data) => promise<unit>,
    index: string => objStore,
    openCursor: (. unit) => promise<cursor>,
  }
  type transaction = {objectStore: string => objStore, store: objStore, done: promise<unit>}

  type openDbOptions = {
    upgrade?: db => unit,
    blocked?: (~currentVersion: int, ~blockedVersion: int, ~event: unit) => unit,
    blocking?: (~currentVersion: int, ~blockedVersion: int, ~event: unit) => unit,
    terminated?: unit => unit,
  }
  type deleteDbOptions = {blocked: unit => unit}
  @module("idb")
  external openDB: (
    ~name: string,
    ~version: int=?,
    ~options: openDbOptions=?,
    unit,
  ) => promise<db> = "openDB"
  @module("idb")
  external deleteDB: (~name: string, ~options: deleteDbOptions=?, unit) => promise<unit> =
    "deleteDB"
  @module("idb") external wrap: unWrappedDB => wrappedDB = "wrap"
  @module("idb") external unwrap: wrappedDB => unWrappedDB = "unwrap"
  @send
  external createObjectStore: (~db: db, ~storeName: string, ~options: objStoreOptions) => objStore =
    "createObjectStore"
  @send
  external createTransaction: (~db: db, ~storeName: string, ~mode: string=?, unit) => transaction =
    "transaction"
  @send
  external createIndex: (~objStore: objStore, ~indexName: string, ~keyPath: string) => unit =
    "createIndex"
  @send external getDBValue: (~db: db, ~storeName: string, ~key: 'key) => promise<'val> = "get"
  @send
  external getDBValueFromIndex: (
    ~db: db,
    ~storeName: string,
    ~indexName: string,
    ~key: 'key,
  ) => promise<'val> = "getFromIndex"
  @send
  external getDBAllValueFromIndex: (
    ~db: db,
    ~storeName: string,
    ~indexName: string,
  ) => promise<'val> = "getAllFromIndex"
  @send
  external getDBKeyFromIndex: (
    ~db: db,
    ~storeName: string,
    ~indexName: string,
    ~key: 'key,
  ) => promise<'val> = "getKeyFromIndex"
  @send
  external addDBValue: (
    ~db: db,
    ~storeName: string,
    ~data: 'data,
    ~key: 'key=?,
    unit,
  ) => promise<unit> = "add"
  @send
  external putDBValue: (
    ~db: db,
    ~storeName: string,
    ~data: 'data,
    ~key: 'key=?,
    unit,
  ) => promise<'val> = "put"
  @send
  external deleteDBValue: (~db: db, ~storeName: string, ~key: 'key) => promise<'val> = "delete"
  @send
  external clearDBValue: (~db: db, ~storeName: string) => promise<unit> = "clear"
}
