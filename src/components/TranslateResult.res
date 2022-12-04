open Widget
open Utils
open TranslateHook

@react.component
let make = (~loading=No, ~data, ~errText="", ~className="") => {
  <div className={`${className} lw-scroll-wrap max-h-52 overflow-y-auto overscroll-contain`}>
    {switch loading {
    | Yes => <Loading />
    | No =>
      switch errText !== "" {
      | true => <div className="text-error"> {React.string(errText)} </div>
      | false =>
        switch data {
        | Baidu(br) => <MachineTPanel data=br />
        | Dict(dr) => <DictPanel data=dr />
        | _ => React.null
        }
      }
    | Noop => React.null
    }}
  </div>
}
