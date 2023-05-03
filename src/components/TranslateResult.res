open Widget
open Utils
open TranslateHook

@react.component
let make = (~loading=No, ~data, ~errText="", ~className="") => {
  let spanning = switch loading {
  | Yes => true
  | _ => false
  }
  <div className={`${className} lw-scroll-wrap max-h-52 overflow-y-auto overscroll-contain`}>
    <Loading loading={spanning} delay=450>
      {switch errText !== "" {
      | true => <div className="text-error"> {React.string(errText)} </div>
      | false =>
        switch data {
        | BaiduT({baidu: br}) => <MachineTPanel data=br />
        | DictT({dict: dr}) => <DictPanel data=dr />
        | _ => React.null
        }
      }}
    </Loading>
  </div>
}
