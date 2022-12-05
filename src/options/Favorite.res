open Promise
open Utils
open Common.Chrome

@react.component
let make = () => {
  let (records, setRecords) = React.Uncurried.useState(_ => [])
  React.useEffect0(() => {
    sendMessage(. {_type: FAVORITE(GETALL)})
    ->thenResolve(ret => {
      setRecords(. _ => ret)
    })
    ->ignore

    None
  })
  let recordEles = Js.Array2.map(records, v => {
    <div className="card card-compact w-80 bg-base-100 shadow-xl">
      <div className="card-body">
        <div className="border-b pb-1">
          <div className="flex justify-between">
            <span> {React.string(Js.Date.toLocaleDateString(Js.Date.fromFloat(v["date"])))} </span>
            <a target="_blank" title={v["title"]} href={v["url"]}>
              <img className="w-5" src={v["favIconUrl"]} />
            </a>
          </div>
          <p className="font-bold text-xl line-clamp-1"> {React.string(v["text"])} </p>
        </div>
        <TranslateResult data={v["trans"]} />
      </div>
    </div>
  })
  <div className="flex flex-wrap gap-4"> {React.array(recordEles)} </div>
}
