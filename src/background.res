open Promise
open Utils
open Common

Chrome.addMessageListener((message, _, sendResponse) => {
  Baidu.translate(message)
  ->then(ret => {
    sendResponse(. ret)
  })
  ->ignore

  // async operation must return `true`
  true
})
