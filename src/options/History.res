open RecordHook

@react.component
let make = () => {
  let {records, onCheck, onCancel, onClear, onDelete, onSearch} = useRecord(History)

  let recordEles = records->Js.Array2.map(record => {
    let {date, title, url, text, favIconUrl, checked} = record
    let boarderClass = checked ? "border-primary" : ""

    <div
      key={Js.Float.toString(date)}
      onClick={_ => onCheck(. record)}
      className={`card card-compact card-bordered cursor-pointer bg-base-100 shadow-xl ${boarderClass}`}>
      <div className="card-body">
        <div className="flex justify-between">
          <span className="w-40">
            {React.string(Js.Date.toLocaleString(Js.Date.fromFloat(date)))}
          </span>
          <a className="inline-flex gap-2" target="_blank" href={url}>
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
