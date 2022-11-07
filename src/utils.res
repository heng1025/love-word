open Promise
open Common
open Common.Chrome
open Common.Webapi.Window

module Baidu = {
  type config = {
    appid: string,
    key: string,
  }

  type result = {
    error_code?: string,
    error_msg?: string,
    from?: string,
    to?: string,
    trans_result?: Js.Array2.t<{"dst": string, "src": string}>,
  }

  let endpoint = "https://api.fanyi.baidu.com/api/trans/vip/translate"

  let translate = q => {
    getExtStorage(~keys=["baiduKey"])
    ->thenResolve(result => {
      let appid = result["baiduKey"]["appid"]
      let key = result["baiduKey"]["secret"]
      let salt = Js.Float.toString(Js.Date.now())
      let sign = Md5.createMd5(appid ++ q ++ salt ++ key)
      `${endpoint}?q=${q}&from=auto&to=zh&appid=${appid}&salt=${salt}&sign=${sign}`
    })
    ->then(ret => fetch(~input=ret, ()))
    ->then(res => Response.json(res))
    ->then(data => {
      switch data.error_msg {
      | Some(msg) => Error(msg)
      | None =>
        switch data.trans_result {
        | Some(trans_result) => Ok(trans_result[0]["dst"])
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
