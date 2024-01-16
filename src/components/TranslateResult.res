open Widget
open Utils

module StatelessTPanel = {
  @react.component
  let make = (~data, ~className=?) => {
    let baseClasses = "lw-scroll-wrap max-h-52 overflow-y-auto overscroll-contain"
    let classes = switch className {
    | Some(cl) => `${baseClasses} ${cl}`
    | _ => baseClasses
    }
    <div dataTestId="transWrap" className=classes>
      {switch data {
      | DictT(dr) => <DictPanel data=dr />
      | BaiduT(br) => <MachineTPanel data=br />
      }}
    </div>
  }
}

@react.component
let make = (~loading=false, ~data: option<transRWithError>, ~delay=0, ~className="") => {
  <Loading loading delay>
    {switch data {
    | Some(Error(msg)) => <div role="alert" className="text-error"> {React.string(msg)} </div>
    | Some(Ok(val)) =>
      switch Nullable.toOption(val) {
      | Some(v) => <StatelessTPanel className data=v />
      | _ => React.string("No translation")
      }
    | _ => React.null
    }}
  </Loading>
}
