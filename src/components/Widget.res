module Loading = {
  @react.component
  let make = () => {
    <div> {React.string("loading...")} </div>
  }
}

module Tag = {
  @react.component
  let make = (~className="", ~children) => {
    <span className={`rounded-sm inline-block px-1 ${className}`}> children </span>
  }
}
