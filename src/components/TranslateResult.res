open TranslateHook

@react.component
let make = (~q, ~className) => {
  let {loading, data, errText} = useTranslate(q)

  <div className={`${className} lw-scroll-wrap max-h-52 overflow-y-auto overscroll-contain`}>
    {switch loading {
    | Yes => <Loading />
    | No =>
      switch errText !== "" {
      | true => <div> {React.string(errText)} </div>
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
