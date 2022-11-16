open Promise
open Common
open Common.Chrome
open Common.Webapi.Window

module Baidu = {
  type result = {
    error_msg?: string,
    trans_result?: Js.Array2.t<{"src": string, "dst": string}>,
  }

  let endpoint = "https://api.fanyi.baidu.com/api/trans/vip/translate"

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
        | Some(trans_result) => Ok(trans_result)
        | None => Error("No Tralation")
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
