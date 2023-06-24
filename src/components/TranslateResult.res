open Widget
open Utils

module TranslateResult = {
  @react.component
  let make = (~data, ~className="") => {
    <div className={`${className} lw-scroll-wrap max-h-52 overflow-y-auto overscroll-contain`}>
      {switch data {
      | DictT(dr) => <DictPanel data=dr />
      | BaiduT(br) => <MachineTPanel data=br />
      }}
    </div>
  }
}

module TranslateResultWithState = {
  @react.component
  let make = (~loading=false, ~data, ~delay=0, ~className="") => {
    <Loading loading delay>
      {switch data {
      | Some(Error(msg)) => <div className="text-error"> {React.string(msg)} </div>
      | Some(Ok(val)) => <TranslateResult className data=val />
      | _ => React.null
      }}
    </Loading>
  }
}
