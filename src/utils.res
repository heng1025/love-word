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
      target: Dom.element,
      stopPropagation: @uncurry (. unit) => unit,
    }
  }
}

open Promise
open Webapi

@scope("window") @val
external windowInnerWidth: int = "innerWidth"
@scope("window") @val
external getSelection: unit => int = "getSelection"
@scope("window") @val
external addWindowEventListener: (string, @uncurry (MouseEvent.t => unit)) => unit =
  "addEventListener"
@scope("window") @val
external removeWindowEventListener: (string, @uncurry (MouseEvent.t => unit)) => unit =
  "removeEventListener"

@val
external fetch: (. string) => Promise.t<'a> = "fetch"

@scope(("chrome", "runtime")) @val
external getURL: (. string) => string = "getURL"
@scope(("chrome", "runtime")) @val
external sendMessage: 'a = "sendMessage"
@scope(("chrome", "runtime", "onMessage")) @val
external addExtListener: (@uncurry ('a, 'b, 'c) => bool) => unit = "addListener"

let translate: string => Promise.t<string> = (text: string) => {
  sendMessage(. text)
  ->then(ret => {
    resolve(ret)
  })
  ->catch(_ => {
    resolve("~Oops Err~")
  })
}
