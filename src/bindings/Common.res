module Webapi = {
  module Element = {
    @get external style: Dom.element => Js.Dict.t<string> = "style"
    @send external text: (Dom.element, string) => string = "text"
    @send external contains: (Js.Nullable.t<Dom.element>, Dom.element) => bool = "contains"
    @send external focus: Dom.element => unit = "focus"
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
    @scope("window") @val
    external windowInnerWidth: int = "innerWidth"
    @scope("window") @val
    external getSelection: unit => int = "getSelection"
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
      @send external json: t<'data> => Promise.t<'data> = "json"
    }

    @val
    external fetch: (~input: string, ~init: init<int>=?, unit) => Promise.t<Response.t<'result>> =
      "fetch"
  }
}

module Chrome = {
  @scope(("chrome", "runtime")) @val
  external getURL: string => string = "getURL"
  @scope(("chrome", "runtime")) @val
  external sendMessage: 'a = "sendMessage"
  @scope(("chrome", "runtime", "onMessage")) @val
  external addMessageListener: (@uncurry ('a, 'b, 'c) => bool) => unit = "addListener"

  @scope(("chrome", "storage", "onChanged")) @val
  external addStorageListener: (@uncurry ('changes, 'areaName) => unit) => unit = "addListener"

  @scope(("chrome", "storage", "local")) @val
  external getExtStorage: (~keys: 'keys=?) => Promise.t<'object> = "get"
  @scope(("chrome", "storage", "local")) @val
  external setExtStorage: (~items: 'items) => Promise.t<unit> = "set"
}

module Md5 = {
  @module("md5") @val external createMd5: string => string = "default"
}
