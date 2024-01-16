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

let baiduRecord = {
  url: "1r21.cn",
  title: "Love Word",
  favIconUrl: "",
  date: 1702484430247.0,
  text: "你好",
  translation: Nullable.make(BaiduT(baiduData)),
  checked: false,
  sync: false,
}

let dictRecord = {
  url: "1r21.cn",
  title: "Love Word",
  favIconUrl: "",
  date: 1702484481543.0,
  text: "hello",
  translation: Nullable.make(DictT(dictData)),
  checked: false,
  sync: false,
}
