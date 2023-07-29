open Common.Chrome
open Common.Idb
open Widget
open Utils
open Utils.Lib
open Database

let dbInstance = getDB()

@react.component
let make = (~onSubmit, ~onCancel) => {
  let (username, setUsername) = React.Uncurried.useState(_ => "")
  let (password, setPassword) = React.Uncurried.useState(_ => "")
  let (passwordVisible, setPasswordVisible) = React.Uncurried.useState(_ => true)

  let getRecordsWithServer = async recordType => {
    let recordMsg = switch recordType {
    | Favorite => FavExtraMsgContent(GetAll)
    | History => HistoryExtraMsgContent(GetAll)
    }
    // local
    let retLocal: array<recordDataWithExtra> = await sendMessage(recordMsg)
    // server
    let retFromServers = switch await recordRemoteAction(~recordType) {
    | Ok(val) => val
    | Error(_) => []
    }

    // strategy: local first
    let tranverseLocals = ref(retLocal)
    if Js.Array2.length(tranverseLocals.contents) === 0 {
      tranverseLocals := retFromServers
    }

    let db = await dbInstance

    let concatLocalWithRemote = (acc, local) => {
      local.sync = false
      Js.Array2.forEach(retFromServers, remote => {
        let isTextExisted = local.text === remote.text
        if isTextExisted {
          local.sync = true
          // update local
          putDBValue(~db, ~storeName=recordType, ~data=local, ())->ignore
        } else {
          remote.sync = true
          if Js.Array2.every(tranverseLocals.contents, v => v.text !== remote.text) {
            let _ = Js.Array2.push(acc, remote)
          }
        }
      })
      acc
    }

    let records: array<recordDataWithExtra> = Js.Array2.reduce(
      tranverseLocals.contents,
      concatLocalWithRemote,
      [],
    )
    let tx = createTransaction(~db, ~storeName=recordType, ~mode="readwrite", ())
    let pstores = Js.Array2.map(records, item => {
      tx.store.add(Obj.magic(item))
    })
    let _len = Js.Array2.push(pstores, tx.done)
    let _ = await Js.Promise2.all(pstores)
  }

  let handleSubmit = async () => {
    switch await fetchByHttp(
      ~url="/login",
      ~method="post",
      ~body={"username": username, "password": password},
    ) {
    | Ok(val) => {
        setExtStorage(~items={"user": val})->ignore
        // sync records
        let _f = await getRecordsWithServer(Favorite)
        let _h = await getRecordsWithServer(History)
        onSubmit(val)
      }
    | _ => ()
    }
  }

  <div>
    <h3> {React.string("Login")} </h3>
    <div className="form-control ">
      <label className="label">
        <span className="label-text"> {React.string("Username")} </span>
      </label>
      <input
        type_="text"
        placeholder="Username"
        value={username}
        onChange={e => {
          setUsername(_ => ReactEvent.Form.target(e)["value"])
        }}
        className="input input-bordered input-primary w-full"
      />
    </div>
    <div className="form-control mt-5">
      <label className="label">
        <span className="label-text"> {React.string("Password")} </span>
      </label>
      <div className="relative">
        <input
          type_={passwordVisible ? "password" : "text"}
          placeholder="Password"
          value={password}
          onChange={e => {
            setPassword(_ => ReactEvent.Form.target(e)["value"])
          }}
          className="input input-bordered input-primary w-full pr-8"
        />
        <span
          className="cursor-pointer absolute w-6 h-6 top-1/2 right-1.5 -translate-y-1/2"
          onClick={_ => setPasswordVisible(_p => !passwordVisible)}>
          {passwordVisible ? <EyeSlash /> : <Eye />}
        </span>
      </div>
    </div>
    <div className="modal-action fle mt-8 justify-center">
      <button className="btn btn-primary" onClick={_ => handleSubmit()->ignore}>
        {React.string("Submit")}
      </button>
      <label className="btn" onClick={_ => onCancel()}> {React.string("close")} </label>
    </div>
  </div>
}
