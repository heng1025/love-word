open Promise
open Utils
open Common.Chrome
open Belt.Float

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
  let recordEles =
    records
    ->Js.Array2.sortInPlaceWith((v1, v2) => Belt.Float.toInt(v2["date"] - v1["date"]))
    ->Js.Array2.map(v => {
      <div className="card card-compact w-[19.5rem] bg-base-100 shadow-xl">
        <div className="card-body">
          <div className="border-b pb-1">
            <div className="flex justify-between">
              <span>
                {React.string(Js.Date.toLocaleDateString(Js.Date.fromFloat(v["date"])))}
              </span>
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
