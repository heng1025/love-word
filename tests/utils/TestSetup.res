open TestBinding
open TestBinding.Vitest

// chrome
self["chrome"] = {
  "runtime": {
    "sendMessage": vi->fn,
    "onMessage": {
      "addListener": vi->fn,
    },
  },
  "storage": {
    "local": {
      "get": vi->fn,
      "set": vi->fn,
      "remove": vi->fn,
    },
  },
}
