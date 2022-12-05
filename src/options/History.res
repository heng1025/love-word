open Promise
open Utils
open Common.Chrome
open Belt.Float

@react.component
let make = () => {
  let (records, setRecords) = React.Uncurried.useState(_ => [])

  let getAll = () => {
    sendMessage(. {_type: HISTORY(GETALL)})
    ->thenResolve(ret => {
      let rs = Js.Array2.map(ret, v => {
        v["checked"] = false
        v
      })->Js.Array2.sortInPlaceWith((v1, v2) => Belt.Float.toInt(v2["date"] - v1["date"]))
      setRecords(._ => rs)
    })
    ->ignore
  }

  React.useEffect0(() => {
    getAll()
    None
  })

  let onCheck = record => {
    let rs = Js.Array2.map(records, v => {
      let date = record["date"]
      let checked = record["checked"]

      if date === v["date"] {
        v["checked"] = !checked
      }
      v
    })
    setRecords(._ => rs)
  }

  let onDelete = checkedRecords => {
    sendMessage(. {_type: HISTORY(DELETE), date: Js.Array2.map(checkedRecords, v => v["date"])})
    ->thenResolve(_ => {
      getAll()
    })
    ->ignore
  }

  let onClear = () => {
    sendMessage(. {_type: HISTORY(CLEAR)})
    ->thenResolve(_ => {
      getAll()
    })
    ->ignore
  }

  let recordEles = Js.Array2.map(records, v => {
    let date = v["date"]
    let boarderClass = v["checked"] ? "border-primary" : ""
    <div
      key={Js.Float.toString(date)}
      onClick={_ => onCheck(v)}
      className={`card card-compact card-bordered cursor-pointer bg-base-100 shadow-xl ${boarderClass}`}>
      <div className="card-body">
        <div className="flex justify-between">
          <span> {React.string(Js.Date.toLocaleString(Js.Date.fromFloat(date)))} </span>
          <a className="inline-flex gap-2" target="_blank" href={v["url"]}>
            <span> {React.string(v["title"])} </span>
            <img className="w-5" src={v["favIconUrl"]} />
          </a>
        </div>
        <p className="font-bold text-xl"> {React.string(v["text"])} </p>
      </div>
    </div>
  })
  <div>
    <RecordAction
      className="mb-4" records={Js.Array2.filter(records, v => v["checked"])} onDelete onClear
    />
    <div className="flex flex-col gap-4"> {React.array(recordEles)} </div>
  </div>
}
