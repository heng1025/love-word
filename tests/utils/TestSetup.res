%%raw("import '@testing-library/jest-dom/vitest'")

open TestBinding
open TestBinding.Vitest
open TestBinding.ReactTestingLibrary

afterEach(cleanup)

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
