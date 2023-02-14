open RecordHook

@react.component
let make = () => {
  let {records, onCheck, onCancel, onClear, onDelete, onSearch} = useRecord(Favorite)
  let recordEles = records->Js.Array2.map(record => {
    let {date, title, url, text, favIconUrl, checked} = record
    let boarderClass = checked ? "border-primary" : ""

    <div
      key={Js.Float.toString(date)}
      onClick={_ => onCheck(. record)}
      className={`card card-compact w-72 card-bordered cursor-pointer bg-base-100 shadow-xl ${boarderClass}`}>
      <div className="card-body">
        <div className="border-b pb-1">
          <div className="flex justify-between">
            <span> {React.string(Js.Date.toLocaleDateString(Js.Date.fromFloat(date)))} </span>
            <a target="_blank" title href=url>
              <img className="w-5" src={favIconUrl} />
            </a>
          </div>
          <p className="font-bold text-xl line-clamp-1"> {React.string(text)} </p>
        </div>
        {switch record.trans {
        | Some(val) => <TranslateResult data=val />
        | _ => React.null
        }}
      </div>
    </div>
  })

  <>
    <RecordAction
      records={Js.Array2.filter(records, v => v.checked)} onCancel onDelete onClear onSearch
    />
    <div className="flex flex-wrap gap-4 p-5"> {React.array(recordEles)} </div>
  </>
}
