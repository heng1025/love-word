@react.component
let make = () => {
  <div className="flex flex-col h-screen">
    <div className="navbar bg-primary text-primary-content">
      <a className="btn btn-ghost normal-case text-xl"> {React.string("Love Word")} </a>
    </div>
    <div className="flex flex-1">
      <ul className="menu bg-base-100 w-56 p-2 border-r text-base">
        <li>
          <span className="active"> {React.string("Translate Service")} </span>
        </li>
        <div className="divider" />
        <li className="menu-title">
          <span> {React.string("User")} </span>
        </li>
        <li>
          <a> {React.string("Favorite")} </a>
        </li>
        <li>
          <a> {React.string("History Query")} </a>
        </li>
      </ul>
      <div className="flex-1 p-5 bg-base-200">
        <div className="card w-1/3 bg-base-100 shadow-xl">
          <div className="card-body">
            <TranslateService />
          </div>
        </div>
      </div>
    </div>
  </div>
}
