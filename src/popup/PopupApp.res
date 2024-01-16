open Common.Webapi
open Widget
open TranslateResult
open! TranslateHook

@react.component
let make = () => {
  let (text, setText) = React.Uncurried.useState(_ => "")
  let (sourceText, setSourceText) = React.Uncurried.useState(_ => "")

  let textInput = React.useRef(Nullable.null)
  let {loading, data} = useTranslate(sourceText)

  let setTextInputRef = element => {
    textInput.current = element
  }

  let focusTextInput = () => {
    switch textInput.current->Nullable.toOption {
    | Some(input) => input->Element.focus
    | None => ()
    }
  }

  let handleTranslate = _ => {
    if text !== "" {
      setSourceText(_ => text)
    } else {
      focusTextInput()
    }
  }

  let handleChange = event => {
    let value = ReactEvent.Form.target(event)["value"]
    setText(_ => value)
  }

  let handleKeyDown = evt => {
    let isCtrlKey = ReactEvent.Keyboard.ctrlKey(evt)
    let key = ReactEvent.Keyboard.key(evt)

    if isCtrlKey && key === "Enter" {
      setSourceText(_ => text)
    }
  }

  // default focus
  React.useEffect(() => {
    focusTextInput()
    None
  }, [])

  <div className="card card-compact w-56 bg-base-100 shadow-xl rounded-none">
    <div className="bg-primary h-5 px-1 text-white flex items-center justify-end">
      {switch data {
      | Some(Ok(val)) => <FavButton text=sourceText trans=val />
      | _ => React.null
      }}
      <Link href={`https://fanyi.baidu.com/#en/zh/${sourceText}`} className="mx-1 tooltip-bottom">
        <Jump />
      </Link>
      <Link href="/options.html">
        <Settting />
      </Link>
    </div>
    <div className="card-body">
      <div className="relative">
        <textarea
          className="textarea textarea-primary w-full leading-4 min-h-16 p-2"
          placeholder="please input..."
          value={text}
          rows={5}
          onChange={handleChange}
          onKeyDown={handleKeyDown}
          ref={ReactDOM.Ref.callbackDomRef(setTextInputRef)}
        />
        <button
          className="btn btn-circle btn-xs btn-primary p-1 absolute bottom-2 right-1"
          onClick={handleTranslate}>
          <Search />
        </button>
      </div>
      <TranslateResult className="text-sm" loading data delay=200 />
    </div>
  </div>
}
