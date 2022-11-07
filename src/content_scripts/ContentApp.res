open Promise
open Common.Chrome
open Common.Webapi
open Common.Webapi.Window
open Utils

@@warning("-44")
let common = getURL("assets/common.css")

@react.component
let make = () => {
  let containerEl = React.useRef(Js.Nullable.null)
  let (top, setTop) = React.Uncurried.useState(_ => "0")
  let (left, setLeft) = React.Uncurried.useState(_ => "0")
  let (opacity, setOpactity) = React.Uncurried.useState(_ => "0")
  let (loading, setLoading) = React.Uncurried.useState(_ => Noop)
  let (errText, seErrText) = React.Uncurried.useState(_ => "")
  let (results, setResults) = React.Uncurried.useState(_ => [])
  let (isMouseClick, setMouseClick) = React.Uncurried.useState(_ => false)

  let updatePos = (ev: MouseEvent.t) => {
    // get mouse position
    let x = ev.pageX - 50
    let y = ev.pageY + 30
    open Js.Int

    setTop(._p => `${toString(y)}px`)
    setLeft(._p => `${toString(x)}px`)
  }

  let showTransPanel = (target: Dom.element) => {
    let text = Js.String2.trim(Js.Int.toString(getSelection()))
    if text !== "" && loading === Noop && !Element.contains(containerEl.current, target) {
      setLoading(._ => Yes)
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

      setOpactity(._p => "1")
    }
  }

  React.useEffect1(() => {
    let firtTime = ref(Js.Int.toFloat(0))
    let lastTime = ref(Js.Int.toFloat(0))

    let handleMouseDown = (e: MouseEvent.t) => {
      e.stopPropagation(.)
      firtTime := Js.Date.now()
    }

    let handleMouseUp = (ev: MouseEvent.t) => {
      ev.stopPropagation(.)
      lastTime := Js.Date.now()
      open Belt.Float
      let delta = Belt.Float.toInt(lastTime.contents - firtTime.contents)

      let clickState = delta < 250
      setMouseClick(._p => clickState)

      if !clickState && ev.altKey {
        updatePos(ev)
        showTransPanel(ev.target)
      }
    }

    let handleDblclick = (ev: MouseEvent.t) => {
      if ev.altKey {
        updatePos(ev)
        showTransPanel(ev.target)
      }
    }

    let handleKeyup = (ev: KeyboardEvent.t) => {
      // altkey (left or right)
      if ev.keyCode === 18 {
        showTransPanel(ev.target)
      }
    }

    addMouseEventListener("mousedown", handleMouseDown)
    addMouseEventListener("dblclick", handleDblclick)
    addMouseEventListener("mouseup", handleMouseUp)
    addKeyboardEventListener("keyup", handleKeyup)

    Some(
      () => {
        removeMouseEventListener("mousedown", handleMouseDown)
        removeMouseEventListener("dblclick", handleDblclick)
        removeMouseEventListener("mouseup", handleMouseUp)
        removeKeyboardEventListener("keyup", handleKeyup)
      },
    )
  }, [])

  React.useEffect2(() => {
    let handleClick = (e: MouseEvent.t) => {
      e.stopPropagation(.)
      if isMouseClick && opacity === "1" && !Element.contains(containerEl.current, e.target) {
        setOpactity(._p => "0")
        setResults(._p => [])
        setMouseClick(._p => false)
      }
    }
    addMouseEventListener("click", handleClick)
    Some(
      () => {
        removeMouseEventListener("click", handleClick)
      },
    )
  }, (isMouseClick, opacity))

  let style = ReactDOM.Style.make(~top, ~left, ~opacity, ())
  <div style className="absolute z-[99999]" ref={ReactDOM.Ref.domRef(containerEl)}>
    <link rel="stylesheet" href={common} />
    <div className="card w-52 bg-primary text-primary-content">
      <div className="card-body p-4">
        <h4 className="card-title text-sm"> {React.string("译文：")} </h4>
        <TranslateResult loading errText results className="text-sm min-h-6" />
      </div>
    </div>
  </div>
}
