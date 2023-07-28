open RecordHook

@react.component
let make = () => {
  let {records, onCheck, onCancel, onClear, onDelete, onSearch} = useRecord(History)

  let recordEles = records->Js.Array2.map(record => {
    let {date, title, url, text, favIconUrl, checked, sync} = record
    let boarderClass = checked ? "border-primary" : ""

    <div
      key={Js.Float.toString(date)}
      onClick={_ => onCheck(record)}
      className={`card card-compact card-bordered cursor-pointer bg-base-100 shadow-xl ${boarderClass}`}>
      <div className="card-body">
        <div className="flex gap-2 justify-between">
          <div className="w-50">
            <span> {React.string(Js.Date.toLocaleString(Js.Date.fromFloat(date)))} </span>
            <span className="ml-4"> {React.string(sync ? "sync" : "")} </span>
          </div>
          <a className="inline-flex gap-2 flex-1 justify-end" target="_blank" href={url}>
            <span className="line-clamp-1"> {React.string(title)} </span>
            <img className="w-5" src={favIconUrl} />
          </a>
        </div>
        <p className="font-bold text-xl"> {React.string(text)} </p>
      </div>
    </div>
  })
  <>
    <RecordAction
      records={Js.Array2.filter(records, v => v.checked)} onCancel onDelete onClear onSearch
    />
    <div className="flex flex-col gap-y-4 p-5"> {React.array(recordEles)} </div>
  </>
}
