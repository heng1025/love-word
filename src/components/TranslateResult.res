open Common
open TranslateHook

@react.component
let make = (~q, ~className) => {
  let {loading, results, errText} = useTranslate(q)

  <div className={`${className} lw-scroll-wrap max-h-52 overflow-y-auto overscroll-contain`}>
    {switch loading {
    | Yes => <Loading />
    | No =>
      switch errText !== "" {
      | true => <div> {React.string(errText)} </div>
      | false => {
          let sl = FrancMin.createFranc(q, {minLength: 1, only: ["eng", "cmn"]})
          let len = Js.String2.split(q, " ")
          if Js.Array2.length(len) === 1 && sl === "eng" {
            <DictPanel />
          } else {
            <MachineTPanel results />
          }
        }
      }
    | Noop => React.null
    }}
  </div>
}
