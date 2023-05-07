open Common
open Common.Chrome
open Common.Webapi.Window

let getSourceLang = text => FrancMin.createFranc(text, {minLength: 1, only: ["eng", "cmn"]})

module Lib = {
  let debounce = (. delay, callback) => {
    let timeoutID = ref(Js.Nullable.null)
    let cancelled = ref(false)

    let clearExistingTimeout = () => {
      if !Js.Nullable.isNullable(timeoutID.contents) {
        Js.Nullable.iter(timeoutID.contents, (. timer) => Js.Global.clearTimeout(timer))
      }
    }

    let cancel = (. ()) => {
      clearExistingTimeout()
      cancelled := true
    }
    let wrapper = (. ()) => {
      clearExistingTimeout()

      switch cancelled.contents {
      | false => timeoutID := Js.Nullable.return(Js.Global.setTimeout(() => callback(.), delay))
      | _ => ()
      }
    }

    (wrapper, cancel)
  }
}
module OfflineDict = {
  let apiHost = %raw(`import.meta.env.LW_API_HOST`)
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
      let data: option<dictOk> = await Response.json(res)
      switch data {
      | Some(val) => Ok(val)
      | _ => Error("Word can not find")
      }
    } catch {
    | Js.Exn.Error(err) =>
      switch Js.Exn.message(err) {
      | Some(msg) => Error(msg)
      | _ => Error("")
      }
    | _ => Error("Unexpected error occurred")
    }
  }
}

module Baidu = {
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

type transR =
  | DictT({dict: OfflineDict.dictOk})
  | BaiduT({baidu: array<Baidu.baiduOk>})
type transRWithError = result<transR, string>

type textMsgContent = {text: string}
type datesMsgContent = {dates: array<float>}
type favAddMsgContent = {
  text: string,
  trans: transR,
}

type extraAction = GetAll | Clear

type recordData = {
  url: string,
  title: string,
  favIconUrl: string,
  date: float,
  text: string,
  trans?: transR,
}

type recordDataWithExtra = {
  url: string,
  title: string,
  favIconUrl: string,
  date: float,
  text: string,
  trans?: transR,
  mutable checked: bool,
}

type msgContent =
  | TranslateMsgContent(textMsgContent)
  // favorite
  | FavAddMsgContent(favAddMsgContent)
  | FavGetOneMsgContent(textMsgContent)
  | FavDeleteOneMsgContent(textMsgContent)
  | FavDeleteManyMsgContent(datesMsgContent)
  | FavExtraMsgContent(extraAction)
  // history
  | HistoryAddMsgContent(textMsgContent)
  | HistoryDeleteManyMsgContent(datesMsgContent)
  | HistoryExtraMsgContent(extraAction)

let adapterTrans = async text => {
  let sl = getSourceLang(text)
  let wordCount = Js.String2.split(text, " ")

  let baiduResult = async () => {
    switch await Baidu.translate(text) {
    | Ok(res) => Ok(BaiduT({baidu: res}))
    | Error(msg) => Error(msg)
    }
  }

  if sl !== "eng" || Js.Array2.length(wordCount) > 4 {
    await baiduResult()
  } else {
    switch await OfflineDict.translate(text) {
    | Ok(val) => Ok(DictT({dict: val}))
    | _ => await baiduResult()
    }
  }
}
