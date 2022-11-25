open Promise
open Utils
open Common

Chrome.addMessageListener((message, _, sendResponse) => {
  adapterTrans(message)
  ->then(ret => {
    sendResponse(. ret)
  })
  ->ignore

  // async operation must return `true`
  true
})
