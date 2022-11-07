open Promise
open Common.Chrome
open Common.Webapi
open Utils

@react.component
let make = () => {
  let (loading, setLoading) = React.Uncurried.useState(_ => Noop)
  let (errText, seErrText) = React.Uncurried.useState(_ => "")
  let (results, setResults) = React.Uncurried.useState(_ => [])
  let (text, setText) = React.Uncurried.useState(_ => "")
  let textInput = React.useRef(Js.Nullable.null)
  let setTextInputRef = element => {
    textInput.current = element
  }

  let focusTextInput = _ => {
    textInput.current->Js.Nullable.toOption->Belt.Option.forEach(input => input->Element.focus)
  }

  let handleChange = event => {
    let value = ReactEvent.Form.target(event)["value"]
    setText(._ => value)
  }

  let handleTranslate = _ => {
    if text !== "" {
      setLoading(._p => Yes)
      seErrText(._ => "")
      sendMessage(. text)
      ->thenResolve(ret => {
        switch ret {
        | Ok(trans_result) => setResults(._p => trans_result)
        | Error(msg) => seErrText(._p => msg)
        }
        setLoading(._p => No)
      })
      ->ignore
    } else {
      focusTextInput()
    }
  }

  let handleKeyDown = evt => {
    let isCtrlKey = ReactEvent.Keyboard.ctrlKey(evt)
    let key = ReactEvent.Keyboard.key(evt)

    if isCtrlKey && key === "Enter" {
      handleTranslate()
    }
  }

  // default focus
  React.useEffect0(() => {
    focusTextInput()
    None
  })

  <div className="card card-compact w-56 bg-base-100 shadow-xl">
    <div className="card-body">
      <textarea
        className="textarea textarea-primary leading-4 min-h-16"
        placeholder="please input..."
        value={text}
        rows={5}
        onChange={handleChange}
        onKeyDown={handleKeyDown}
        ref={ReactDOM.Ref.callbackDomRef(setTextInputRef)}
      />
      <button className="btn btn-primary btn-sm m-2" onClick={handleTranslate}>
        {React.string("Translate")}
      </button>
      <TranslateResult loading errText results className="text-secondary p-2 min-h-8" />
    </div>
  </div>
}
