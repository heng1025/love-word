open Common.Webapi.Element
open Common.Webapi.Document

let id = "loveWord"

let host = document->createElement("div")
setAttribute(host, "id", id)
// reset `host` style
setAttribute(host, "style", "all: initial;")

let shadow = attachShadow(host, {"mode": "open"})
appendChild(document->documentElement, host)

ReactDOM.render(<ContentApp host />, shadow)
