open TestBinding
open TestBinding.Vitest
open Common.Chrome
open Utils
open Functions
open TranSource

let fetchSpy = vi->spyOn(self, "fetch")

let chromeGetStoreSpy = vi->spyOn(chromeStore, "get")
let chromeSetStoreSpy = vi->spyOn(chromeStore, "set")
let chromeRmStoreSpy = vi->spyOn(chromeStore, "remove")

let createMockHttpResponse = (~code=0, ~msg="", ~data=?) => {
  let apiBaseResponse: api<'a> = {
    code,
    msg,
    data,
  }

  {
    "json": () => apiBaseResponse,
  }
}

let dictData: OfflineDict.dictOk = {
  id: 1,
  word: "hello",
  translation: "interj. 喂, 嘿",
  phonetic: "hә'lәu",
  tag: "zk gk",
}

let baiduData: array<Baidu.baiduOk> = [
  {
    src: "你好",
    dst: "hello",
  },
]
