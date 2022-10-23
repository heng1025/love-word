open Promise
open Utils
open Utils.Webapi
open Utils.Webapi.Element

@@warning("-44")
let common = getURL(. "assets/common.css")

type loading = Yes | No | None

@react.component
let make = () => {
  let containerEl = React.useRef(Js.Nullable.null)
  let (top, setTop) = React.Uncurried.useState(_ => "0")
  let (left, setLeft) = React.Uncurried.useState(_ => "0")
  let (opacity, setOpactity) = React.Uncurried.useState(_ => "0")
  let (loading, setLoading) = React.Uncurried.useState(_ => None)
  let (result, setResult) = React.Uncurried.useState(_ => "")
  let (isMouseClick, setMouseClick) = React.Uncurried.useState(_ => false)

  let showTransPanel = (ev: MouseEvent.t) => {
    // get mouse position
    let x = ev.pageX - 50
    let y = ev.pageY + 30

    let raw = Js.String2.trim(Js.Int.toString(getSelection()))
    if raw !== "" && !contains(containerEl.current, ev.target) {
      setLoading(._ => Yes)
      translate(raw)
      ->then(ret => {
        setLoading(._ => No)
        setResult(._p => ret)
        resolve()
      })
      ->ignore

      open Js.Int

      setTop(._p => `${toString(y)}px`)
      setLeft(._p => `${toString(x)}px`)
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

    let handleMouseUp = (e: MouseEvent.t) => {
      e.stopPropagation(.)
      lastTime := Js.Date.now()
      open Belt.Float
      let delta = Belt.Float.toInt(lastTime.contents - firtTime.contents)

      let clickState = delta < 250
      setMouseClick(._p => clickState)

      if !clickState {
        showTransPanel(e)
      }
    }

    addWindowEventListener("mousedown", handleMouseDown)
    addWindowEventListener("dblclick", showTransPanel)
    addWindowEventListener("mouseup", handleMouseUp)

    Some(
      () => {
        removeWindowEventListener("mousedown", handleMouseDown)
        removeWindowEventListener("dblclick", showTransPanel)
        removeWindowEventListener("mouseup", handleMouseUp)
      },
    )
  }, [])

  React.useEffect2(() => {
    let handleClick = (e: MouseEvent.t) => {
      e.stopPropagation(.)
      if isMouseClick && opacity === "1" && !contains(containerEl.current, e.target) {
        setOpactity(._p => "0")
        setResult(._p => "")
        setMouseClick(._p => false)
      }
    }
    addWindowEventListener("click", handleClick)
    Some(
      () => {
        removeWindowEventListener("click", handleClick)
      },
    )
  }, (isMouseClick, opacity))

  let style = ReactDOM.Style.make(~top, ~left, ~opacity, ())
  <div style className="absolute" ref={ReactDOM.Ref.domRef(containerEl)}>
    <link rel="stylesheet" href={common} />
    <div className="card w-52 bg-primary text-primary-content">
      <div className="card-body p-4">
        <h4 className="card-title text-sm"> {React.string("翻译结果：")} </h4>
        <p className="text-sm min-h-6">
          {switch loading {
          | Yes => React.string("loading...")
          | No => React.string(result)
          | None => React.null
          }}
        </p>
      </div>
    </div>
  </div>
}
