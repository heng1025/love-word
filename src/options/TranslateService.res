open Promise
open Common.Chrome
open Widget

type baiduConfig = {
  appid: string,
  secret: string,
}

type baiduStore = {baiduKey?: baiduConfig}

@react.component
let make = () => {
  let (appid, setAppid) = React.Uncurried.useState(_ => "")
  let (secret, setSecret) = React.Uncurried.useState(_ => "")
  let (warnVisibleClass, setWarnVisibleClass) = React.Uncurried.useState(_ => "hidden")

  React.useEffect0(() => {
    getExtStorage(~keys=["baiduKey"])
    ->then(result => {
      switch result.baiduKey {
      | Some(config) => {
          setAppid(. _ => config.appid)
          setSecret(. _ => config.secret)
        }

      | _ => ()
      }
      resolve()
    })
    ->ignore
    None
  })

  let handleSubmit = _ => {
    if appid === "" || secret === "" {
      setWarnVisibleClass(._ => "block")
    } else {
      let config = {appid, secret}
      setWarnVisibleClass(._ => "hidden")
      setExtStorage(~items={baiduKey: config})->ignore
    }
  }

  <div className="card w-1/3 bg-base-100 shadow-xl">
    <div className="card-body">
      <div className="form-control ">
        <label className="label">
          <span className="label-text"> {React.string("baidu appid")} </span>
        </label>
        <input
          type_="text"
          placeholder="Appid"
          value={appid}
          onChange={e => setAppid(._ => ReactEvent.Form.target(e)["value"])}
          className="input input-bordered input-primary w-full"
        />
      </div>
      <div className="form-control mt-5">
        <label className="label">
          <span className="label-text"> {React.string("baidu secret")} </span>
        </label>
        <input
          type_="text"
          placeholder="Secret"
          value={secret}
          onChange={e => setSecret(._ => ReactEvent.Form.target(e)["value"])}
          className="input input-bordered input-primary w-full"
        />
      </div>
      <div className={`alert alert-warning shadow-lg mt-5 ${warnVisibleClass}`}>
        <div>
          <Alert />
          <span> {React.string("Warning: input can not be empty!")} </span>
        </div>
      </div>
      <button className="btn btn-primary w-5/6 mt-8 mx-auto" onClick={handleSubmit}>
        {React.string("Submit")}
      </button>
    </div>
  </div>
}
