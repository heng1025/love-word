open Widget
open Functions
open! TranslateResult

open Common.Webapi
open Common.Webapi.Window

let panelDelay = 200

@react.component
let make = (~host) => {
  let (sourceText, setSourceText) = React.Uncurried.useState(_ => "")
  let (srcLang, setSrcLang) = React.Uncurried.useState(_ => "eng")
  let (top, setTop) = React.Uncurried.useState(_ => "0")
  let (left, setLeft) = React.Uncurried.useState(_ => "0")
  let (opacity, setOpactity) = React.Uncurried.useState(_ => "0")

  let {loading, data} = TranslateHook.useTranslate(sourceText)

  let showTransPanel = range => {
    let rect = range->getBoundingClientRect
    let posOffset = 8.0
    let top = rect.top +. rect.height +. Int.toFloat(Window.scrollY)
    let left = rect.left +. Int.toFloat(Window.scrollX)
    setTop(_p => `${Float.toString(top +. posOffset)}px`)
    setLeft(_p => `${Float.toString(left)}px`)
    let (showPanel, _) = debounce(panelDelay, () => {
      setOpactity(_p => "1")
    })
    showPanel()
  }

  React.useEffect(() => {
    let handleKeyup = (ev: KeyboardEvent.t) => {
      // altkey (left or right)
      if ev.keyCode === 18 {
        let selection = getSelection()
        let text = String.trim(selection->selectionToString)
        if rangeCount(selection) > 0 && text !== "" {
          let range = getRangeAt(selection, 0)
          let sl = getSourceLang(text)
          setSrcLang(_ => sl)
          setSourceText(_ => text)
          showTransPanel(range)
        }
      }
    }

    addKeyboardEventListener("keyup", handleKeyup)

    Some(() => removeKeyboardEventListener("keyup", handleKeyup))
  }, [])

  React.useEffect(() => {
    let handleClick = (e: MouseEvent.t) => {
      e.stopPropagation()
      if opacity === "1" && !Element.contains(host, e.target) {
        setTop(_ => "0")
        setLeft(_ => "0")
        setOpactity(_p => "0")
        setSourceText(_ => "")
      }
    }
    addMouseEventListener("click", handleClick)
    Some(
      () => {
        removeMouseEventListener("click", handleClick)
      },
    )
  }, [opacity])

  let mouseState = React.useMemo(() => {
    switch opacity {
    | "1" => "pointer-events-auto select-auto"
    | _ => "pointer-events-none select-none"
    }
  }, [opacity])

  let style = ReactDOM.Style.make(~top, ~left, ~opacity, ())
  <div style className={`absolute z-[99999] ${mouseState}`}>
    <div className="card w-52 bg-primary text-primary-content">
      <div className="card-body p-3">
        <h4 className="card-title text-sm border-b justify-between">
          <span>
            {switch srcLang {
            | "eng" => <En2zh />
            | "cmn" => <Zh2en />
            | _ => React.null
            }}
          </span>
          <div className="flex items-center">
            {switch data {
            | Some(Ok(val)) => <FavButton text=sourceText trans=val />
            | _ => React.null
            }}
            <Link href={`https://fanyi.baidu.com/#en/zh/${sourceText}`}>
              <Jump />
            </Link>
          </div>
        </h4>
        <TranslateResult className="text-sm" data loading delay=panelDelay />
      </div>
    </div>
  </div>
}
