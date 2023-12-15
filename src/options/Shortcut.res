@react.component
let make = () => {
  <div className="card card-compact w-40 bg-base-100 shadow-xl">
    <div className="card-body">
      <div className="bg-base-100 font-bold"> {React.string("Assist key")} </div>
      <div className="form-control">
        <label className="label cursor-pointer">
          <span className="label-text"> {React.string("ALT")} </span>
          <input type_="checkbox" defaultChecked=true className="checkbox" />
        </label>
      </div>
    </div>
  </div>
}
