open Promise
open Utils
open Common.Chrome

@react.component
let make = () => {
  let (records, setRecords) = React.Uncurried.useState(_ => [])
  React.useEffect0(() => {
    sendMessage(. {_type: HISTORY(GETALL)})
    ->thenResolve(ret => {
      setRecords(. _ => ret)
    })
    ->ignore

    None
  })

  let recordEles = Js.Array2.map(records, v => {
    <div className="card card-compact bg-base-100 shadow-xl m-4">
      <div className="card-body">
        <div className="flex justify-between">
          <span> {React.string(Js.Date.toLocaleString(Js.Date.fromFloat(v["date"])))} </span>
          <a className="inline-flex gap-2" target="_blank" href={v["url"]}>
            <span> {React.string(v["title"])} </span>
            <img className="w-5" src={v["favIconUrl"]} />
          </a>
        </div>
        <p className="font-bold text-xl"> {React.string(v["text"])} </p>
      </div>
    </div>
  })
  <div> {React.array(recordEles)} </div>
}
