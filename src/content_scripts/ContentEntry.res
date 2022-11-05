open Common.Webapi.Element
open Common.Webapi.Document

let id = "love-word"

let host = document->createElement("div")
setAttribute(host, "id", id)

let shadow = attachShadow(host, {"mode": "open"})
appendChild(document->documentElement, host)

ReactDOM.render(<ContentApp />, shadow)
