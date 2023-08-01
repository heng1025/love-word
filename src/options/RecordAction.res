type state = DELETE | SYNC | CLEAR | None

@scope(("window", "recordAction")) @val
external showModal: unit => unit = "showModal"
@scope(("window", "recordAction")) @val
external closeModal: unit => unit = "close"

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
    <dialog id="recordAction" className="modal">
      <form method="dialog" className="modal-box">
        <h3 className="font-bold text-lg"> {React.string("Do you confirm?")} </h3>
        <div className="modal-action">
          <button className="btn btn-error" onClick> {React.string("Confirm")} </button>
          <button className="btn"> {React.string("Cancel")} </button>
        </div>
      </form>
    </dialog>
    <div className="flex gap-5 items-center">
      <input
        type_="text"
        placeholder="Search..."
        className="input input-primary w-full max-w-xs"
        onChange={e => handleChange(ReactEvent.Form.target(e)["value"])}
      />
      {switch checkedLen > 0 {
      | true =>
        <div className="join">
          <button
            className="btn btn-warning join-item"
            onClick={_ => {
              setBtnState(_ => DELETE)
              showModal()
            }}>
            <span> {React.string("Delete")} </span>
            <span> {React.string(`(${Js.Int.toString(checkedLen)})`)} </span>
          </button>
          <button
            className="btn btn-secondary join-item"
            onClick={_ => {
              setBtnState(_ => SYNC)
              showModal()
            }}>
            <span> {React.string("Sync")} </span>
            <span> {React.string(`(${Js.Int.toString(checkedLen)})`)} </span>
          </button>
          <button
            className="btn btn-error join-item"
            onClick={_ => {
              setBtnState(_ => CLEAR)
              showModal()
            }}>
            {React.string("Clear")}
          </button>
          <button className="btn join-item" onClick={_ => onCancel()}>
            {React.string("Cancel")}
          </button>
        </div>
      | false => React.null
      }}
    </div>
  </div>
}
