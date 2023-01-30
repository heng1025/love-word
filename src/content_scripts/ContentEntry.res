open Common.Webapi.Element
open Common.Webapi.Document

let id = "loveWord"

let host = document->createElement("div")
setAttribute(host, "id", id)
// reset `host` style
setAttribute(host, "style", "all: initial;")

let shadowEl = attachShadow(host, {"mode": "open"})
appendChild(document->documentElement, host)

let shadow = ReactDOM.Client.createRoot(shadowEl)
ReactDOM.Client.Root.render(shadow, <ContentApp host />)
