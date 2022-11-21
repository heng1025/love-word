open Common.Chrome
open Common.Webapi
open Common.Webapi.Window

@@warning("-44")
let common = getURL("assets/common.css")

@react.component
let make = (~host) => {
  let (top, setTop) = React.Uncurried.useState(_ => "0")
  let (left, setLeft) = React.Uncurried.useState(_ => "0")
  let (opacity, setOpactity) = React.Uncurried.useState(_ => "0")

  let hook = TranslateHook.useTranslate()

  let showTransPanel = (range, text) => {
    let rect = range->getBoundingClientRect
    open Js.Float
    let posOffset = 8.0
    let top = rect.top +. rect.height +. Js.Int.toFloat(Window.scrollY)
    let left = rect.left +. Js.Int.toFloat(Window.scrollX)
    setTop(._p => `${toString(top +. posOffset)}px`)
    setLeft(._p => `${toString(left)}px`)
    hook.handleTranslate(. text)
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
          showTransPanel(range, text)
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
        <h4 className="card-title text-sm border-b"> {React.string("译文：")} </h4>
        <TranslateResult
          loading={hook.loading} errText={hook.errText} results={hook.results} className="text-sm"
        />
      </div>
    </div>
  </div>
}
