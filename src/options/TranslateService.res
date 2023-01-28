open Promise
open Common.Chrome
open Widget
open Utils

@react.component
let make = () => {
  let (appid, setAppid) = React.Uncurried.useState(_ => "")
  let (secret, setSecret) = React.Uncurried.useState(_ => "")
  let (warnMessage, setWarnMessage) = React.Uncurried.useState(_ => "")

  React.useEffect0(() => {
    getExtStorage(~keys=["baiduKey"])
    ->then(result => {
      switch Js.toOption(result["baiduKey"]) {
      | Some(config) => {
          setAppid(. _ => config["appid"])
          setSecret(. _ => config["secret"])
        }

      | _ => ()
      }
      resolve()
    })
    ->ignore
    None
  })

  let handleSubmit = _ => {
    let config = {"appid": appid, "secret": secret}
    setExtStorage(~items={"baiduKey": config})->ignore
    // test baidu key
    Baidu.translate("hello world")
    ->then(br => {
      switch br {
      | Ok(_) => {
          setWarnMessage(._ => "")
          setExtStorage(~items={"baiduKey": config})->ignore
        }

      | Error(msg) => {
          removeExtStorage(~keys=["baiduKey"])->ignore
          setWarnMessage(._ => msg)
        }
      }->resolve
    })
    ->ignore
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
      {switch warnMessage !== "" {
      | true =>
        <div className="alert alert-warning shadow-lg mt-5">
          <div>
            <Alert />
            <span> {React.string(`Warning: ${warnMessage}!`)} </span>
          </div>
        </div>
      | false => React.null
      }}
      <button className="btn btn-primary w-5/6 mt-8 mx-auto" onClick={handleSubmit}>
        {React.string("Submit")}
      </button>
    </div>
  </div>
}
