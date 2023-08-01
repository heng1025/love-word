open Common.Chrome

type user = Logined({email: string, profileImage: string, token: string}) | UnLogined

@scope(("window", "login")) @val
external showModal: unit => unit = "showModal"
@scope(("window", "login")) @val
external closeModal: unit => unit = "close"

@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()
  let (user, setUser) = React.Uncurried.useState(_ => UnLogined)

  React.useEffect0(() => {
    let getUser = async () => {
      let result = await getExtStorage(~keys=["user"])
      let u = result["user"]
      setUser(_ => u)
    }
    getUser()->ignore
    None
  })

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

  let logout = _ => {
    removeExtStorage(~keys=["user"])->ignore
    setUser(_ => UnLogined)
  }

  let hasLoginedComponent =
    <div className="dropdown dropdown-end">
      <label tabIndex={0} className="btn btn-ghost btn-circle avatar">
        <div className="w-10 rounded-full">
          <img
            src={switch user {
            | Logined({profileImage: v}) => v
            | _ => ""
            }}
          />
        </div>
      </label>
      <ul
        tabIndex={1}
        className="mt-3 z-[99] p-2 shadow menu menu-compact dropdown-content bg-base-100 border border-slate-500 rounded-box w-52">
        <li>
          <a className="justify-between"> {React.string("Profile")} </a>
        </li>
        <li onClick=logout>
          <a> {React.string("Logout")} </a>
        </li>
      </ul>
    </div>

  let loginStatus = switch user {
  | Logined(_) => hasLoginedComponent
  | _ => <button className="btn" onClick={_ => showModal()}> {React.string("Login")} </button>
  }

  <div>
    <div className="flex flex-col h-screen">
      <div className="navbar bg-base-100 border-b-2">
        <div className="flex-1">
          <a className="btn btn-ghost normal-case text-xl" href="#service">
            <img src="/icons/lw32x32.png" className=" inline-block mr-2" />
            {React.string("Love Word")}
          </a>
        </div>
        <div className="flex-none gap-2"> loginStatus </div>
        <dialog id="login" className="modal">
          <form method="dialog" className="modal-box">
            <Login
              onSubmit={u => {
                setUser(u)
                closeModal()
              }}
              onCancel={_ => closeModal()}
            />
          </form>
        </dialog>
      </div>
      <div className="flex flex-1 overflow-y-hidden">
        <div className="overflow-y-auto border-r-2">
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
              <a className={activeClass("shortcut")} href="#shortcut">
                {React.string("Shortcut")}
              </a>
            </li>
            <div className="divider" />
            <li className="menu-title">
              <span> {React.string("User")} </span>
            </li>
            <li>
              <a className={activeClass("favorite")} href="#favorite">
                {React.string("Favorite")}
              </a>
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
  </div>
}
