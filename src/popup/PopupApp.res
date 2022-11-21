open Common.Webapi

@react.component
let make = () => {
  let (text, setText) = React.Uncurried.useState(_ => "")
  let textInput = React.useRef(Js.Nullable.null)

  let setTextInputRef = element => {
    textInput.current = element
  }

  let focusTextInput = () => {
    textInput.current->Js.Nullable.toOption->Belt.Option.forEach(input => input->Element.focus)
  }

  let hook = TranslateHook.useTranslate()

  let handleTranslate = _ => {
    if text !== "" {
      hook.handleTranslate(. text)
    } else {
      focusTextInput()
    }
  }

  let handleChange = event => {
    let value = ReactEvent.Form.target(event)["value"]
    setText(._ => value)
  }

  let handleKeyDown = evt => {
    let isCtrlKey = ReactEvent.Keyboard.ctrlKey(evt)
    let key = ReactEvent.Keyboard.key(evt)

    if isCtrlKey && key === "Enter" {
      hook.handleTranslate(. text)
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
        className="textarea textarea-primary leading-4 min-h-16 p-2"
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
      <TranslateResult
        loading={hook.loading}
        errText={hook.errText}
        results={hook.results}
        className="text-secondary p-2 min-h-8"
      />
    </div>
  </div>
}
