open Utils
open RecordHook

@react.component
let make = () => {
  let {records, onCheck, onCancel, onClear, onDelete, onSearch} = useRecord(HISTORY)

  let recordEles = records->Js.Array2.map(v => {
    let date = v["date"]
    let boarderClass = v["checked"] ? "border-primary" : ""
    <div
      key={Js.Float.toString(date)}
      onClick={_ => onCheck(. v)}
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
  <>
    <RecordAction
      className="mb-4"
      records={Js.Array2.filter(records, v => v["checked"])}
      onCancel
      onDelete
      onClear
      onSearch
    />
    <div className="flex flex-col gap-y-4"> {React.array(recordEles)} </div>
  </>
}
