open Promise
open Utils
open Common

Chrome.addMessageListener((message, _, sendResponse) => {
  Baidu.translate(message)
  ->then(ret => {
    let res = switch ret {
    | Error(msg) => msg
    | Ok(data) => data
    }
    sendResponse(. res)
  })
  ->ignore

  // async operation must return `true`
  true
})
