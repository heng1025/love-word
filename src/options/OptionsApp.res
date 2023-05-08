@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  React.useEffect1(() => {
    if url.hash === "" {
      RescriptReactRouter.push("#service")
    }
    None
  }, [url])

  let contentClass = React.useMemo1(() => {
    let isRecordUrl = Js.Array2.includes(["favorite", "history"], url.hash)
    switch isRecordUrl {
    | false => "p-5"
    | true => ""
    }
  }, [url.hash])

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
    <div className="flex flex-1 overflow-y-hidden">
      <div className="overflow-y-auto border-r">
        <ul className="menu bg-base-100 w-56 p-2">
          <li className="menu-title">
            <span> {React.string("Setting")} </span>
          </li>
          <li>
            <a className={activeClass("service")} href="#service">
              {React.string("Translate Service")}
            </a>
          </li>
          <li>
            <a className={activeClass("shortcut")} href="#shortcut"> {React.string("Shortcut")} </a>
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
      </div>
      <div className={`flex-1 overflow-y-auto bg-base-200 ${contentClass}`}>
        {switch url.hash {
        | "service" => <TranslateService />
        | "shortcut" => <Shortcut />
        | "favorite" => <Favorite />
        | "history" => <History />
        | _ => React.string("Page Not Found")
        }}
      </div>
    </div>
  </div>
}
