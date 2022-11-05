open Promise
open Common.Chrome

@react.component
let make = () => {
  let (appid, setAppid) = React.Uncurried.useState(_ => "")
  let (secret, setSecret) = React.Uncurried.useState(_ => "")
  let (warnVisibleClass, setWarnVisibleClass) = React.Uncurried.useState(_ => "hidden")

  React.useEffect0(() => {
    getExtStorage(~keys=["baiduKey"])
    ->then(result => {
      setAppid(. _ => result["baiduKey"]["appid"])
      setSecret(. _ => result["baiduKey"]["secret"])
      resolve()
    })
    ->ignore
    None
  })

  let handleSubmit = _ => {
    if appid === "" || secret === "" {
      setWarnVisibleClass(._ => "block")
    } else {
      setWarnVisibleClass(._ => "hidden")
      setExtStorage(~items={"baiduKey": {"appid": appid, "secret": secret}})->ignore
    }
  }

  <div className="flex justify-center">
    <div className="w-2/5">
      <div className="form-control w-full">
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
      <div className="form-control w-full mt-5">
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
          <svg
            xmlns="http://www.w3.org/2000/svg"
            className="stroke-current flex-shrink-0 h-6 w-6"
            fill="none"
            viewBox="0 0 24 24">
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="2"
              d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
            />
          </svg>
          <span> {React.string("Warning: input can not be empty!")} </span>
        </div>
      </div>
      <button className="btn btn-primary w-full mt-5" onClick={handleSubmit}>
        {React.string("Submit")}
      </button>
    </div>
  </div>
}
