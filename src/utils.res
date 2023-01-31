open Common
open Common.Chrome
open Common.Webapi.Window

type actionType = ADD | GET | GETALL | DELETE | CLEAR
type recordType = HISTORY | FAVORITE
type msgType = TRASTALTE | Message(recordType, actionType)

let getSourceLang = text => FrancMin.createFranc(text, {minLength: 1, only: ["eng", "cmn"]})

module OfflineDict = {
  let apiHost = %raw(`import.meta.env.VITE_API_HOST`)
  let endpoint = `${apiHost}/dict`

  type dictOk = {
    id: int,
    word: string,
    translation: string,
    phonetic: string,
    definition: string,
    tag: string,
    exchange: string,
  }

  let translate = async q => {
    try {
      let res = await fetch(~input=`${endpoint}?q=${q}`, ())
      let data = await Response.json(res)
      switch Js.toOption(data) {
      | Some(val) => Ok(val)
      | _ => Error("Word can not find")
      }
    } catch {
    | Js.Exn.Error(err) =>
      switch Js.Exn.message(err) {
      | Some(msg) => Error(msg)
      | None => Error("")
      }
    | _ => Error("Unexpected error occurred")
    }
  }
}

module Baidu = {
  let endpoint = "https://api.fanyi.baidu.com/api/trans/vip/translate"

  type baiduOk = Js.Array2.t<{
    "src": string,
    "dst": string,
    @set
    "isPlay": bool,
    @set
    "sourceVisible": bool,
  }>

  type response = {
    error_msg?: string,
    trans_result?: baiduOk,
  }

  let textToSpeech = text => {
    let query = Qs.stringify({
      "word": text,
      "le": "zh",
    })

    `https://tts.youdao.com/fanyivoice?${query}`
  }

  let translate = async q => {
    try {
      let result = await getExtStorage(~keys=["baiduKey"])

      let baiduKey = result["baiduKey"]
      let queryUrl = switch Js.toOption(baiduKey) {
      | Some(key) => {
          let appid = key["appid"]
          let key = key["secret"]
          let salt = Js.Float.toString(Js.Date.now())
          let sign = Md5.createMd5(appid ++ q ++ salt ++ key)
          let sl = getSourceLang(q)
          // zh->eng, other -> zh
          let tlDict = Js.Dict.fromList(list{("cmn", "en")})

          let query = Qs.stringify({
            "q": q,
            "from": "auto",
            "to": switch Js.Dict.get(tlDict, sl) {
            | Some(val) => val
            | _ => "zh"
            },
            "appid": appid,
            "salt": salt,
            "sign": sign,
          })
          `${endpoint}?${query}`
        }

      | None => Js.Exn.raiseError("No translation key")
      }
      let res = await fetch(~input=queryUrl, ())

      let data = await Response.json(res)

      switch data.error_msg {
      | Some(msg) => Error(msg)
      | None =>
        switch data.trans_result {
        | Some(val) => Ok(val)
        | None => Error("No Translation")
        }
      }
    } catch {
    | Js.Exn.Error(err) =>
      switch Js.Exn.message(err) {
      | Some(msg) => Error(msg)
      | None => Error("")
      }
    | _ => Error("Unexpected error occurred")
    }
  }
}

type resultT = Dict(OfflineDict.dictOk) | Baidu(Baidu.baiduOk) | Message(string)

type msgContent = {
  _type: msgType,
  date?: array<float>,
  text?: string,
  trans?: resultT,
}

let adapterTrans = async text => {
  let sl = getSourceLang(text)
  let wordCount = Js.String2.split(text, " ")

  let baiduResult = async () => {
    switch await Baidu.translate(text) {
    | Ok(res) => Baidu(res)
    | Error(msg) => Message(msg)
    }
  }

  if sl !== "eng" || Js.Array2.length(wordCount) > 4 {
    await baiduResult()
  } else {
    switch await OfflineDict.translate(text) {
    | Ok(val) => Dict(val)
    | _ => await baiduResult()
    }
  }
}
