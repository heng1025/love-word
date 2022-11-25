open Promise
open Common
open Common.Chrome
open Common.Webapi.Window

module OfflineDict = {
  let endpoint = "http://dict.1r21.cn/dict"
  type dictOk = {
    id: int,
    word: string,
    translation: string,
    phonetic: string,
    definition: string,
    tag: string,
    exchange: string,
  }

  let translate = q => {
    fetch(~input=`${endpoint}?q=${q}`, ())
    ->then(res => Response.json(res))
    ->then(data => {
      switch data {
      | Some(val) => Ok(val)
      | _ => Error("Word can not find")
      }->resolve
    })
    ->catch(e => {
      let msg = switch e {
      | JsError(err) =>
        switch Js.Exn.message(err) {
        | Some(msg) => msg
        | None => ""
        }
      | _ => "Unexpected error occurred"
      }

      Error(msg)->resolve
    })
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

  let translate = q => {
    getExtStorage(~keys=["baiduKey"])
    ->thenResolve(result => {
      let appid = result["baiduKey"]["appid"]
      let key = result["baiduKey"]["secret"]
      let salt = Js.Float.toString(Js.Date.now())
      let sign = Md5.createMd5(appid ++ q ++ salt ++ key)
      let sl = FrancMin.createFranc(q, {minLength: 1, only: ["eng", "cmn"]})
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
    })
    ->then(ret => fetch(~input=ret, ()))
    ->then(res => Response.json(res))
    ->then(data => {
      switch data.error_msg {
      | Some(msg) => Error(msg)
      | None =>
        switch data.trans_result {
        | Some(val) => Ok(val)
        | None => Error("No Translation")
        }
      }->resolve
    })
    ->catch(e => {
      let msg = switch e {
      | JsError(err) =>
        switch Js.Exn.message(err) {
        | Some(msg) => msg
        | None => ""
        }
      | _ => "Unexpected error occurred"
      }

      Error(msg)->resolve
    })
  }
}

type resultT = Dict(OfflineDict.dictOk) | Baidu(Baidu.baiduOk) | Message(string)

let adapterTrans = text => {
  let sl = FrancMin.createFranc(text, {minLength: 1, only: ["eng", "cmn"]})
  let wordCount = Js.String2.split(text, " ")

  let baiduResult = Baidu.translate(text)->then(br => {
    switch br {
    | Ok(res) => Baidu(res)
    | Error(msg) => Message(msg)
    }->resolve
  })

  if Js.Array2.length(wordCount) > 4 || sl !== "eng" {
    baiduResult
  } else {
    OfflineDict.translate(text)->then(ret => {
      switch ret {
      | Ok(val) => Dict(val)->resolve
      | _ => baiduResult
      }
    })
  }
}
