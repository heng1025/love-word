type state = DELETE | SYNC | CLEAR | None

@react.component
let make = (~records=[], ~onDelete, ~onSync, ~onClear, ~onSearch, ~onCancel) => {
  let (btnState, setBtnState) = React.Uncurried.useState(_ => None)
  let checkedLen = Js.Array2.length(records)

  let onClick = _ => {
    switch btnState {
    | DELETE => onDelete(records)
    | SYNC => onSync(records)
    | CLEAR => onClear()
    | _ => ()
    }
  }

  let handleChange = val => {
    onSearch(val)
  }
  <div className="sticky top-0 z-40 bg-base-100 p-4 border-b-2">
    <input type_="checkbox" id="my-modal" className="modal-toggle" />
    <div className="modal">
      <div className="modal-box">
        <h3 className="font-bold text-lg"> {React.string("Do you confirm?")} </h3>
        <div className="modal-action">
          <div className="btn-group">
            <label htmlFor="my-modal" className="btn btn-error" onClick>
              {React.string("Confirm")}
            </label>
            <label htmlFor="my-modal" className="btn"> {React.string("Cancel")} </label>
          </div>
        </div>
      </div>
    </div>
    <div className="flex gap-5 items-center">
      <input
        type_="text"
        placeholder="Search..."
        className="input input-primary w-full max-w-xs"
        onChange={e => handleChange(ReactEvent.Form.target(e)["value"])}
      />
      {switch checkedLen > 0 {
      | true =>
        <div className="btn-group">
          <label
            htmlFor="my-modal"
            className="btn btn-warning gap-2"
            onClick={_ => setBtnState(_ => DELETE)}>
            <span> {React.string("Delete")} </span>
            <span> {React.string(`(${Js.Int.toString(checkedLen)})`)} </span>
          </label>
          <label
            htmlFor="my-modal"
            className="btn btn-secondary gap-2"
            onClick={_ => setBtnState(_ => SYNC)}>
            <span> {React.string("Sync")} </span>
            <span> {React.string(`(${Js.Int.toString(checkedLen)})`)} </span>
          </label>
          <label
            htmlFor="my-modal" className="btn btn-error" onClick={_ => setBtnState(_ => CLEAR)}>
            {React.string("Clear")}
          </label>
          <button className="btn" onClick={_ => onCancel()}> {React.string("Cancel")} </button>
        </div>
      | false => React.null
      }}
    </div>
  </div>
}
