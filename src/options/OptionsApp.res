open Common.Chrome
open Common.Idb
open Utils
open Database

type user = Logined({email: string, profileImage: string, token: string}) | UnLogined

@scope(("window", "login")) @val
external showModal: unit => unit = "showModal"
@scope(("window", "login")) @val
external closeModal: unit => unit = "close"

let getRecordsWithServer = async recordType => {
  let recordMsg = switch recordType {
  | Favorite => FavExtraMsgContent(GetAll)
  | History => HistoryExtraMsgContent(GetAll)
  }
  // local
  let retLocal: array<recordDataWithExtra> = await chromeRuntime->sendMessage(recordMsg)

  // server
  let retFromServers = switch await recordRemoteAction(~recordType) {
  | Ok(val) => val
  | Error(_) => []
  }

  // strategy: local first
  let tranverseLocals = ref(retLocal)
  if Array.length(tranverseLocals.contents) === 0 {
    tranverseLocals := retFromServers
  }

  let db = await getDB()

  let concatLocalWithRemote = (acc, local) => {
    local.sync = false
    Array.forEach(retFromServers, remote => {
      let isTextExisted = local.text === remote.text
      if isTextExisted {
        local.sync = true
        // update local
        putDBValue(~db, ~storeName=recordType, ~data=local, ())->ignore
      } else {
        remote.sync = true
        let isNotAtLocal = Array.every(tranverseLocals.contents, v => v.text !== remote.text)
        let isNotAtAcc = Array.every(acc, v => v.text !== remote.text)
        if isNotAtLocal && isNotAtAcc {
          let _ = Array.push(acc, remote)
        }
      }
    })
    acc
  }

  let records = tranverseLocals.contents->Array.reduce([], concatLocalWithRemote)
  let tx = createTransaction(~db, ~storeName=recordType, ~mode="readwrite", ())
  let pstores = Array.map(records, item => {
    tx.store.add(Obj.magic(item))
  })
  let _len = Array.push(pstores, tx.done)
  try {
    let _ = await Promise.all(pstores)
  } catch {
  | Js.Exn.Error(err) =>
    switch Error.message(err) {
    | Some(msg) => Console.log(msg)
    | _ => Console.log("Err happen")
    }
  | _ => Console.log("Unexpected error occurred")
  }
}

@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()
  let (user, setUser) = React.Uncurried.useState(_ => UnLogined)

  React.useEffect(() => {
    let getUser = async () => {
      let result = await chromeStore->get(~keys=["user"])
      let u: user = result["user"]
      setUser(_ => u)
    }
    getUser()->ignore
    None
  }, [])

  React.useEffect(() => {
    if url.hash === "" {
      RescriptReactRouter.push("#service")
    }
    None
  }, [url])

  let contentClass = React.useMemo(() => {
    let isRecordUrl = ["favorite", "history"]->Array.includes(url.hash)
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
    chromeStore->remove(~keys=["user"])->ignore
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
  | _ =>
    <button className="btn btn-neutral" onClick={_ => showModal()}>
      {React.string("Login")}
    </button>
  }

  let handleCommit = async user => {
    setUser(user)
    closeModal()
    // sync records
    let _f = await getRecordsWithServer(Favorite)
    let _h = await getRecordsWithServer(History)
  }

  <div className="bg-base-200">
    <div className="flex flex-col gap-1 h-screen">
      <div className="navbar bg-base-100">
        <div className="flex-1">
          <a className="btn btn-ghost normal-case text-xl" href="#service">
            <img src="/icons/lw32x32.png" className=" inline-block mr-2" />
            {React.string("Love Word")}
          </a>
        </div>
        <div className="flex gap-2"> loginStatus </div>
        <dialog id="login" className="modal">
          <form method="dialog" className="modal-box">
            <Login onSubmit={u => handleCommit(u)} onCancel={_ => closeModal()} />
          </form>
        </dialog>
      </div>
      <div className="flex flex-1 gap-1 overflow-y-hidden">
        <div className="overflow-y-auto bg-base-100">
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
