open Widget
open Utils
open TranslateHook

module TranslateResult = {
  @react.component
  let make = (~data, ~className="") => {
    <div className={`${className} lw-scroll-wrap max-h-52 overflow-y-auto overscroll-contain`}>
      {switch data {
      | BaiduT({baidu: br}) => <MachineTPanel data=br />
      | DictT({dict: dr}) => <DictPanel data=dr />
      }}
    </div>
  }
}

module TranslateResultWithState = {
  @react.component
  let make = (~data, ~delay=0, ~className="") => {
    switch data {
    | TLoading(true) => <Loading delay />
    | TError(err) => <div className="text-error"> {React.string(err)} </div>
    | TResult(val) => <TranslateResult className data=val />
    | _ => React.null
    }
  }
}
