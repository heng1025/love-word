open Common
open Common.Chrome
open Common.Http

let apiHost = %raw(`import.meta.env.LW_API_HOST`)
let getSourceLang = text => FrancMin.createFranc(text, {minLength: 1, only: ["eng", "cmn"]})
let includeWith = (target, substring) => Js.Re.fromString(substring)->Js.Re.test_(target)

module Lib = {
  type api<'data> = {
    code: int,
    data: 'data,
    msg: string,
  }
  let fetchByHttp = async (~url, ~method="get", ~body=?) => {
    try {
      let headers = Js.Obj.empty()
      let result = await chromeStore->get(~keys=["user"])
      let user = result["user"]
      let _ = switch Js.toOption(user) {
      | Some(val) => Js.Obj.assign(headers, {"x-token": val["token"]})
      | _ => headers
      }

      let res = switch body {
      | Some(b) =>
        await fetch(
          ~input=`${apiHost}${url}`,
          ~init={method, headers, body: Js.Json.stringifyAny(b)},
          (),
        )
      | _ => await fetch(~input=`${apiHost}${url}`, ~init={headers: headers}, ())
      }
      let json: api<'data> = await Response.json(res)
      switch json.code {
      | 0 => Ok(json.data)
      | _ => Error(json.msg)
      }
    } catch {
    | Js.Exn.Error(err) =>
      switch Js.Exn.message(err) {
      | Some(msg) => Error(msg)
      | _ => Error("Err happen")
      }
    | _ => Error("Unexpected error occurred")
    }
  }

  let debounce = (delay, callback) => {
    let timeoutID = ref(Js.Nullable.null)
    let cancelled = ref(false)

    let clearExistingTimeout = () => {
      if !Js.Nullable.isNullable(timeoutID.contents) {
        Js.Nullable.iter(timeoutID.contents, timer => Js.Global.clearTimeout(timer))
      }
    }

    let cancel = () => {
      clearExistingTimeout()
      cancelled := true
    }
    let wrapper = () => {
      clearExistingTimeout()

      switch cancelled.contents {
      | false => timeoutID := Js.Nullable.return(Js.Global.setTimeout(() => {
              callback()
            }, delay))
      | _ => ()
      }
    }

    (wrapper, cancel)
  }
}

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

  let translate = async q => await Lib.fetchByHttp(~url=`/dict?q=${q}`)
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

type transR =
  | @unboxed DictT(OfflineDict.dictOk)
  | @unboxed BaiduT(array<Baidu.baiduOk>)

type transRWithError = result<Js.Nullable.t<transR>, string>

type recordType = | @as("history") History | @as("favorite") Favorite

type recordItem = {
  text: string,
  date: float,
}
type textMsgContent = {text: string}
type recordsMsgContent = {records: array<recordItem>}
type favAddMsgContent = {
  text: string,
  translation: Js.Nullable.t<transR>,
}

type extraAction = GetAll | Clear

type recordData = {
  url: string,
  title: string,
  favIconUrl: string,
  date: float,
  text: string,
  translation?: Js.Nullable.t<transR>,
}

type recordDataWithExtra = {
  ...recordData,
  mutable checked: bool,
  mutable sync: bool,
}

type msgContent =
  | TranslateMsgContent(textMsgContent)
  // favorite
  | FavGetOneMsgContent(textMsgContent)
  | FavAddMsgContent(favAddMsgContent)
  | FavAddManyMsgContent(array<recordDataWithExtra>)
  | FavDeleteOneMsgContent(textMsgContent)
  | FavDeleteManyMsgContent(recordsMsgContent)
  | FavExtraMsgContent(extraAction)
  // history
  | HistoryAddMsgContent(textMsgContent)
  | HistoryAddManyMsgContent(array<recordDataWithExtra>)
  | HistoryDeleteManyMsgContent(recordsMsgContent)
  | HistoryExtraMsgContent(extraAction)

let recordRemoteAction = async (~recordType: recordType, ~data=?, ~method="post") => {
  let loginInfo = await chromeStore->get(~keys=["user"])
  switch Js.toOption(loginInfo["user"]) {
  | Some(_) => {
      let rType = switch recordType {
      | Favorite => "2"
      | History => "1"
      }
      let url = `/records?type=${rType}`
      switch data {
      | Some(v) => await Lib.fetchByHttp(~url, ~body=v, ~method)
      | _ => await Lib.fetchByHttp(~url)
      }
    }
  | _ => Error("nothing")
  }
}
