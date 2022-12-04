open Promise
open Utils
open Common.Chrome

@react.component
let make = () => {
  let (texts, setTexts) = React.Uncurried.useState(_ => [])
  React.useEffect0(() => {
    sendMessage(. {_type: FAVORITE(GETALL)})
    ->then(ret => {
      setTexts(. _ => ret)
      resolve()
    })
    ->ignore

    None
  })
  let textsEle = Js.Array2.map(texts, v => {
    <div className="card card-compact w-80 bg-base-100 shadow-xl m-4">
      <div className="card-body">
        <div className="border-b pb-1">
          <div className="flex justify-between">
            <span> {React.string(Js.Date.toLocaleDateString(Js.Date.fromFloat(v["date"])))} </span>
            <a className="w-5" target="_blank" title={v["title"]} href={v["url"]}>
              <img src={v["favIconUrl"]} />
            </a>
          </div>
          <p className="font-bold text-xl line-clamp-1"> {React.string(v["text"])} </p>
        </div>
        <TranslateResult data={v["trans"]} />
      </div>
    </div>
  })
  <div className="flex flex-wrap"> {React.array(textsEle)} </div>
}
