open Common.Chrome
open Common.Webapi
open Common.Webapi.Window

@@warning("-44")
let common = getURL("assets/common.css")

@react.component
let make = (~host) => {
  let (sourceText, setSourceText) = React.Uncurried.useState(_ => "")
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
          setSourceText(._ => text)
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
        <h4 className="card-title text-sm border-b justify-between">
          <span> {React.string("译文：")} </span>
          <a
            className="w-5 link link-primary"
            target="_blank"
            title="show detail"
            href={`https://fanyi.baidu.com/#en/zh/${sourceText}`}>
            <svg
              className="fill-white"
              viewBox="0 0 1024 1024"
              version="1.1"
              xmlns="http://www.w3.org/2000/svg">
              <path
                d="M646.43969701 681.06311061L604.18627955 639.12280248 696.05944825 544.20092748 404.47131347 544.20092748 404.47131347 479.43652318 703.90368678 479.43652318 604.18627955 384.43225123 646.43969701 342.49194311 816.93652344 511.76928686 646.43969701 681.06311061ZM266.81811549 511.76928686C266.81811549 642.61645508 374.03369115 749.07397436 505.82019042 749.07397436L505.82019042 808.40014623C341.07470728 808.40014623 207.06347656 675.32824733 207.06347656 511.76928686 207.06347656 348.22680639 341.07470728 215.13842748 505.82019042 215.13842748L505.82019042 274.46459936C374.03369115 274.46459936 266.81811549 380.92211939 266.81811549 511.76928686Z"
              />
            </svg>
          </a>
        </h4>
        <TranslateResult
          loading={hook.loading} errText={hook.errText} results={hook.results} className="text-sm"
        />
      </div>
    </div>
  </div>
}
