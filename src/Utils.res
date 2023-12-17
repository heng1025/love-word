open Common
open Common.Chrome
open Common.Http
open Functions
open TranSource

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

let adapterTrans = async text => {
  let sl = getSourceLang(text)
  let wordCount = Js.String2.split(text, " ")

  let baiduResult = async () => {
    switch await Baidu.translate(text) {
    | Ok(res) => Ok(BaiduT(res))
    | Error(msg) => Error(msg)
    }
  }

  if sl !== "eng" || Js.Array2.length(wordCount) > 4 {
    await baiduResult()
  } else {
    switch await OfflineDict.translate(text) {
    | Ok(val) => Ok(DictT(val))
    | _ => await baiduResult()
    }
  }
}

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
      | Some(v) => await fetchByHttp(~url, ~body=v, ~method)
      | _ => await fetchByHttp(~url)
      }
    }
  | _ => Error("nothing")
  }
}
