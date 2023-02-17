open Utils
open TranslateHook
open Common.Chrome
open Common.Webapi
open Common.Webapi.Window

open Widget

@@warning("-44")

// if inject css in manifest, it may pollute host page,
// so use shadow dom is a good idea.
let common = getURL("assets/common.css")

@react.component
let make = (~host) => {
  let (sourceText, setSourceText) = React.Uncurried.useState(_ => "")
  let (srcLang, setSrcLang) = React.Uncurried.useState(_ => "eng")
  let (top, setTop) = React.Uncurried.useState(_ => "0")
  let (left, setLeft) = React.Uncurried.useState(_ => "0")
  let (opacity, setOpactity) = React.Uncurried.useState(_ => "0")

  let {loading, data, errText} = useTranslate(sourceText)

  let showTransPanel = range => {
    let rect = range->getBoundingClientRect
    open Js.Float
    let posOffset = 8.0
    let top = rect.top +. rect.height +. Js.Int.toFloat(Window.scrollY)
    let left = rect.left +. Js.Int.toFloat(Window.scrollX)
    setTop(._p => `${toString(top +. posOffset)}px`)
    setLeft(._p => `${toString(left)}px`)
    setOpactity(._p => "1")
  }

  React.useEffect0(() => {
    let handleKeyup = (ev: KeyboardEvent.t) => {
      // altkey (left or right)
      if ev.keyCode === 18 {
        let selection = getSelection()
        let text = Js.String2.trim(selection->selectionToString)
        if rangeCount(selection) > 0 && text !== "" {
          let range = getRangeAt(selection, 0)
          let sl = getSourceLang(text)
          setSrcLang(._ => sl)
          setSourceText(._ => text)
          showTransPanel(range)
        }
      }
    }

    addKeyboardEventListener("keyup", handleKeyup)

    Some(
      () => {
        removeKeyboardEventListener("keyup", handleKeyup)
      },
    )
  })

  React.useEffect1(() => {
    let handleClick = (e: MouseEvent.t) => {
      e.stopPropagation(.)
      if opacity === "1" && !Element.contains(host, e.target) {
        setTop(._ => "0")
        setLeft(._ => "0")
        setOpactity(._p => "0")
        setSourceText(._ => "")
      }
    }
    addMouseEventListener("click", handleClick)
    Some(
      () => {
        removeMouseEventListener("click", handleClick)
      },
    )
  }, [opacity])

  let mouseState = React.useMemo1(() => {
    switch opacity {
    | "1" => "pointer-events-auto select-auto"
    | _ => "pointer-events-none select-none"
    }
  }, [opacity])

  let style = ReactDOM.Style.make(~top, ~left, ~opacity, ())
  <div style className={`absolute z-[99999] ${mouseState}`}>
    <link rel="stylesheet" href={common} />
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
          <div className="flex">
            <FavButton text=sourceText trans=data />
            <a
              className="w-5 link fill-white link-primary"
              target="_blank"
              title="show detail"
              href={`https://fanyi.baidu.com/#en/zh/${sourceText}`}>
              <Jump />
            </a>
          </div>
        </h4>
        <TranslateResult className="text-sm" loading data errText />
      </div>
    </div>
  </div>
}
