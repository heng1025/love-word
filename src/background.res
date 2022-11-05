open Promise
open Utils
open Common

Chrome.addMessageListener((message, _, sendResponse) => {
  Baidu.translate(message)
  ->then(res => {
    sendResponse(. res)
  })
  ->ignore

  // async operation must return `true`
  true
})
