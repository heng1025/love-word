@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  React.useEffect1(() => {
    if url.hash === "" {
      RescriptReactRouter.push("#service")
    }
    None
  }, [url])

  let activeClass = match => {
    switch url.hash === match {
    | true => "active"
    | _ => ""
    }
  }

  <div className="flex flex-col h-screen text-base">
    <div className="navbar bg-primary text-primary-content">
      <a className="btn btn-ghost normal-case text-xl" href="#service">
        {React.string("Love Word")}
      </a>
    </div>
    <div className="flex flex-1">
      <ul className="menu bg-base-100 w-56 p-2 border-r">
        <li className="menu-title">
          <span> {React.string("Setting")} </span>
        </li>
        <li>
          <a className={activeClass("service")} href="#service">
            {React.string("Translate Service")}
          </a>
        </li>
        <div className="divider" />
        <li className="menu-title">
          <span> {React.string("User")} </span>
        </li>
        <li>
          <a className={activeClass("favorite")} href="#favorite"> {React.string("Favorite")} </a>
        </li>
        <li>
          <a className={activeClass("history")} href="#history">
            {React.string("History Query")}
          </a>
        </li>
      </ul>
      <div className="flex-1 p-5 bg-base-200">
        {switch url.hash {
        | "service" => <TranslateService />
        | "favorite" => <Favorite />
        | "history" => <History />
        | _ => React.string("Page Not Found")
        }}
      </div>
    </div>
  </div>
}
