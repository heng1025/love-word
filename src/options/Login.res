open Common.Chrome
open Widget
open Utils.Lib

@react.component
let make = (~onSubmit, ~onCancel) => {
  let (username, setUsername) = React.Uncurried.useState(_ => "")
  let (password, setPassword) = React.Uncurried.useState(_ => "")
  let (passwordVisible, setPasswordVisible) = React.Uncurried.useState(_ => true)

  let handleSubmit = async () => {
    switch await fetchByHttp(
      ~url="/login",
      ~method="post",
      ~body={"username": username, "password": password},
    ) {
    | Ok(val) => {
        Js.log2("val", val)
        setExtStorage(~items={"user": val})->ignore
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
