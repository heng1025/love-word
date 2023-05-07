open Utils
open Widget
open Common.Webapi

@react.component
let make = (~data: array<Baidu.baiduOk>) => {
  let audioEl = React.useRef(Js.Nullable.null)
  let (transList, setTransList) = React.Uncurried.useState(_ => [])

  let isEqual = (text, v: Baidu.baiduOk) => v.src === text || v.dst === text

  React.useEffect1(() => {
    setTransList(._ =>
      Js.Array2.map(
        data,
        v => {
          ...v,
          sourceVisible: false,
          isPlay: false,
        },
      )
    )
    None
  }, [data])

  let onPlay = text => {
    setTransList(.p =>
      Js.Array2.map(p, v => {
        let isPlay = switch v.isPlay {
        | Some(s) => isEqual(text, v) && !s
        | _ => false
        }

        {...v, isPlay}
      })
    )

    audioEl.current
    ->Js.Nullable.toOption
    ->Belt.Option.forEach(audio => {
      let current = Js.Array2.find(transList, v => isEqual(text, v))
      switch current {
      | Some(v) =>
        switch v.isPlay {
        | Some(true) => audio->Element.createAudioSrc("")
        | _ => {
            audio->Element.createAudioSrc(Baidu.textToSpeech(text))
            audio->Element.play
          }
        }
      | _ => ()
      }
    })
  }

  let onEnded = _ => {
    setTransList(.p =>
      Js.Array2.map(p, v => {
        ...v,
        isPlay: false,
      })
    )
  }

  let resultEl = Js.Array2.mapi(transList, (result, idx) => {
    let text = switch result.sourceVisible {
    | Some(true) => result.src
    | _ => result.dst
    }

    let isPlay = switch result.isPlay {
    | Some(true) => true
    | _ => false
    }

    <p key={Js.Int.toString(idx)}>
      <Speaker isPlay onClick={_ => onPlay(text)} className="w-5 h-5 mr-1 align-middle" />
      <span className="align-middle"> {React.string(text)} </span>
    </p>
  })

  <>
    <audio ref={ReactDOM.Ref.domRef(audioEl)} className="w-full h-8 mb-1" onEnded />
    {React.array(resultEl)}
  </>
}
