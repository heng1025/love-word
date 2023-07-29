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
  let make = (~loading=false, ~data: option<transRWithError>, ~delay=0, ~className="") => {
    <Loading loading delay>
      {switch data {
      | Some(Error(msg)) => <div className="text-error"> {React.string(msg)} </div>
      | Some(Ok(val)) =>
        switch Js.Nullable.toOption(val) {
        | Some(v) => <TranslateResult data=v />
        | _ => React.string("No translation")
        }
      | _ => React.null
      }}
    </Loading>
  }
}
