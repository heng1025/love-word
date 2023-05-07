open Common.Webapi
open TranslateResult
open TranslateHook

@react.component
let make = () => {
  let (text, setText) = React.Uncurried.useState(_ => "")
  let (sourceText, setSourceText) = React.Uncurried.useState(_ => "")

  let textInput = React.useRef(Js.Nullable.null)
  let data = useTranslate(sourceText)

  let setTextInputRef = element => {
    textInput.current = element
  }

  let focusTextInput = () => {
    textInput.current->Js.Nullable.toOption->Belt.Option.forEach(input => input->Element.focus)
  }

  let handleTranslate = _ => {
    if text !== "" {
      setSourceText(._ => text)
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
      setSourceText(._ => text)
    }
  }

  // default focus
  React.useEffect0(() => {
    focusTextInput()
    None
  })

  <div className="card card-compact w-56 bg-base-100 shadow-xl rounded-none">
    <div className="bg-primary h-5 text-right">
      {switch data {
      | TResult(val) => <FavButton text=sourceText trans=val />
      | _ => React.null
      }}
    </div>
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
      <TranslateResultWithState className="text-sm" data delay=200 />
    </div>
  </div>
}
