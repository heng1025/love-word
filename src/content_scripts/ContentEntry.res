open Common.Webapi.Element
open! Common.Webapi.Document

@module("../common.css?inline") external commonCss: string = "default"

let id = "__loveWord__"

let host = document->createElement("div")
setAttribute(host, "id", id)
// reset `host` style
setAttribute(host, "style", "all: initial;")

let shadowEl = attachShadow(host, {"mode": "open"})
appendChild(document->documentElement, host)

let shadow = ReactDOM.Client.createRoot(shadowEl)

ReactDOM.Client.Root.render(
  shadow,
  <>
    <style> {React.string(commonCss)} </style>
    <ContentApp host />
  </>,
)
