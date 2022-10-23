open Utils.Webapi.Element
open Utils.Webapi.Document

let id = "love-word"

let host = document->createElement("div")
setAttribute(host, "id", id)

let shadow = attachShadow(host, {"mode": "open"})
appendChild(document->documentElement, host)

ReactDOM.render(<ContentApp />, shadow)
