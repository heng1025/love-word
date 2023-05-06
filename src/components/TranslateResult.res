open Utils

@react.component
let make = (~data, ~className="") => {
  <div className={`${className} lw-scroll-wrap max-h-52 overflow-y-auto overscroll-contain`}>
    {switch data {
    | BaiduT({baidu: br}) => <MachineTPanel data=br />
    | DictT({dict: dr}) => <DictPanel data=dr />
    | TError(errText) => <div className="text-error"> {React.string(errText)} </div>
    }}
  </div>
}
