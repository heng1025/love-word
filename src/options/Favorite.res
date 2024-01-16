open TranslateResult
open RecordHook

@react.component
let make = () => {
  let {records, onCheck, onCancel, onClear, onDelete, onSync, onSearch} = useRecord(Favorite)
  let recordEles = records->Array.map(record => {
    let {date, title, url, text, favIconUrl, checked, sync} = record
    let boarderClass = checked ? "border-primary" : ""

    <div
      key={Float.toString(date)}
      onClick={_ => onCheck(record)}
      className={`card card-compact w-72 card-bordered cursor-pointer bg-base-100 shadow-xl ${boarderClass}`}>
      <div className="card-body">
        <div className="border-b pb-1">
          <div className="flex justify-between">
            <div>
              <span> {React.string(Date.toLocaleDateString(Date.fromTime(date)))} </span>
              <span className="ml-2"> {React.string(sync ? "sync" : "")} </span>
            </div>
            <a target="_blank" title href=url>
              <img className="w-5" src={favIconUrl} />
            </a>
          </div>
          <p className="font-bold text-xl line-clamp-1"> {React.string(text)} </p>
        </div>
        {switch record.translation {
        | Some(val) =>
          switch Nullable.toOption(val) {
          | Some(v) => <StatelessTPanel data=v />
          | _ => React.string("No translation")
          }
        | _ => React.null
        }}
      </div>
    </div>
  })

  <>
    <RecordAction
      records={Array.filter(records, v => v.checked)} onCancel onDelete onSync onClear onSearch
    />
    <div className="flex flex-wrap gap-4 p-5"> {React.array(recordEles)} </div>
  </>
}
