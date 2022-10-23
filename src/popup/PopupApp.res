open Promise
open Utils.Webapi.Element

type loading = Yes | No | None

@react.component
let make = () => {
  let (loading, setLoading) = React.Uncurried.useState(_ => None)
  let (result, setResult) = React.Uncurried.useState(_ => "")
  let (text, setText) = React.Uncurried.useState(_ => "")
  let textInput = React.useRef(Js.Nullable.null)
  let setTextInputRef = element => {
    textInput.current = element
  }

  let focusTextInput = _ => {
    textInput.current->Js.Nullable.toOption->Belt.Option.forEach(input => input->focus)
  }

  let handleChange = event => {
    let value = ReactEvent.Form.target(event)["value"]
    setText(._ => value)
  }

  let translate = _ => {
    if text !== "" {
      setLoading(._p => Yes)
      Utils.translate(text)
      ->then(ret => {
        setResult(._p => ret)
        setLoading(._p => No)
        resolve()
      })
      ->catch(_ => {
        setResult(._p => "~Oops Err~")
        setLoading(._p => No)
        resolve()
      })
      ->ignore
    } else {
      focusTextInput()
    }
  }

  <div className="card card-compact w-56 bg-base-100 shadow-xl">
    <div className="card-body">
      <textarea
        className="textarea textarea-primary"
        placeholder="please input..."
        value={text}
        onChange={handleChange}
        ref={ReactDOM.Ref.callbackDomRef(setTextInputRef)}
      />
      <button className="btn btn-primary btn-sm m-2" onClick={translate}>
        {React.string("Translate")}
      </button>
      <div className="text-secondary p-2 min-h-8">
        {switch loading {
        | Yes => React.string("loading...")
        | No => React.string(result)
        | None => React.null
        }}
      </div>
    </div>
  </div>
}
