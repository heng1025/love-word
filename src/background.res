open Promise
open Js.Array2
open Utils

let endpoint = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=zh-Hans&dt=t"

let translate = (. msg) => {
  fetch(. `${endpoint}&q=${msg}`)
  ->then(ret => ret["json"](.))
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

addMessageListener((message, _, sendResponse) => {
  translate(. message)
  ->then(res => {
    sendResponse(. res)
  })
  ->ignore

  // async operation must return `true`
  true
})
