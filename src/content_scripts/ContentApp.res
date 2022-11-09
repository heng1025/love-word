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

  let showTransPanel = () => {
    let selection = getSelection()
    let range = getRangeAt(selection, 0)
    let rect = range->getBoundingClientRect

    open Js.Float

    setTop(._p => `${toString(rect.top +. rect.height)}px`)
    setLeft(._p => `${toString(rect.left)}px`)
    let text = Js.String2.trim(selection->selectionToString)
    if text !== "" {
      hook.handleTranslate(. text)
      setOpactity(._p => "1")
    }
  }

  React.useEffect0(() => {
    let handleKeyup = (ev: KeyboardEvent.t) => {
      // altkey (left or right)
      if ev.keyCode === 18 {
        showTransPanel()
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

  let style = ReactDOM.Style.make(~top, ~left, ~opacity, ())
  <div style className="absolute z-[99999]">
    <link rel="stylesheet" href={common} />
    <div className="card w-52 bg-primary text-primary-content">
      <div className="card-body p-4">
        <h4 className="card-title text-sm"> {React.string("译文：")} </h4>
        <TranslateResult
          loading={hook.loading}
          errText={hook.errText}
          results={hook.results}
          className="text-sm min-h-6"
        />
      </div>
    </div>
  </div>
}
