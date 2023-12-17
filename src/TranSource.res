open Functions

module OfflineDict = {
  type dictOk = {
    id: int,
    word: string,
    translation: string,
    phonetic: string,
    definition?: string,
    tag: string,
    exchange?: string,
  }

  let translate = async q => await fetchByHttp(~url=`/dict?q=${q}`)
}

module Baidu = {
  open Common
  open Common.Chrome
  open Common.Http

  let endpoint = "https://api.fanyi.baidu.com/api/trans/vip/translate"

  type baiduOk = {
    src: string,
    dst: string,
    mutable isPlay?: bool,
    mutable sourceVisible?: bool,
  }

  type response = {
    error_msg?: string,
    trans_result?: array<baiduOk>,
  }

  let textToSpeech = text => {
    let query = Qs.stringify({
      "audio": text,
      "le": "zh",
    })

    `https://dict.youdao.com/dictvoice?${query}`
  }

  let translate = async q => {
    try {
      let throwErr = () => Js.Exn.raiseError("No translation key")
      let result = switch await chromeStore->get(~keys=["baiduKey"]) {
      | Some(val) => val["baiduKey"]
      | _ => throwErr()
      }

      let queryUrl = switch Js.toOption(result) {
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

      | None => throwErr()
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
      | None => Error("error")
      }
    | _ => Error("Unexpected error occurred")
    }
  }
}
