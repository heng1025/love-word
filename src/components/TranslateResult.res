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
  let make = (~loading=false, ~data, ~delay=0, ~className="") => {
    <Loading loading delay>
      {switch data {
      | TResult(Error(msg)) => <div className="text-error"> {React.string(msg)} </div>
      | TResult(Ok(val)) => <TranslateResult className data=val />
      | _ => React.null
      }}
    </Loading>
  }
}
