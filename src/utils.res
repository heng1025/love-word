open Promise
open Common
open Common.Chrome
open Common.Webapi.Window
module Google = {
  open Js.Array2
  let endpoint = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=zh-Hans&dt=t"

  let translateByGoogle = msg => {
    fetch(~input=`${endpoint}&q=${msg}`, ())
    ->thenResolve(ret => ret["json"](.))
    ->then(result => {
      let txt = switch isArray(result) {
      | false => None
      | true => {
          let fl = result->unsafe_get(0)
          switch isArray(fl) {
          | false => None
          | true => {
              let sl = fl->unsafe_get(0)
              switch isArray(sl) {
              | false => None
              | true => sl->unsafe_get(0)
              }
            }
          }
        }
      }
      resolve(txt)
    })
  }
}
module Baidu = {
  type config = {
    appid: string,
    key: string,
  }

  type error = {
    error_code: string,
    error_msg: string,
  }

  type resultItem = {
    dst: string,
    src: string,
  }

  type result = {
    from: string,
    to: string,
    trans_result: Js.Array2.t<resultItem>,
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
    ->thenResolve(res => res["json"](.))
    ->thenResolve(result => {
      result["trans_result"][0]["dst"]
    })
  }
}
