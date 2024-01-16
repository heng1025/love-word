open Widget
open Common.Webapi
open TranSource

@react.component
let make = (~data: array<Baidu.baiduOk>) => {
  let audioEl = React.useRef(Nullable.null)
  let (transList, setTransList) = React.Uncurried.useState(_ => [])

  let isEqual = (text, v: Baidu.baiduOk) => v.src === text || v.dst === text

  React.useEffect(() => {
    setTransList(_ =>
      data->Array.map(
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
    setTransList(p =>
      Array.map(p, v => {
        let isPlay = switch v.isPlay {
        | Some(s) => isEqual(text, v) && !s
        | _ => false
        }

        {...v, isPlay}
      })
    )

    switch audioEl.current->Nullable.toOption {
    | Some(audio) => {
        let current = transList->Array.find(v => isEqual(text, v))
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
      }
    | None => ()
    }
  }

  let onEnded = _ => {
    setTransList(p =>
      Array.map(p, v => {
        ...v,
        isPlay: false,
      })
    )
  }

  let resultEl = transList->Array.mapWithIndex((result, idx) => {
    let text = switch result.sourceVisible {
    | Some(true) => result.src
    | _ => result.dst
    }

    let isPlay = switch result.isPlay {
    | Some(true) => true
    | _ => false
    }

    <p key={Int.toString(idx)}>
      <Speaker isPlay onClick={_ => onPlay(text)} className="w-5 h-5 mr-1 align-middle" />
      <span className="align-middle"> {React.string(text)} </span>
    </p>
  })

  <>
    <audio
      dataTestId="audioPlayer"
      ref={ReactDOM.Ref.domRef(audioEl)}
      className="w-full h-8 mb-1"
      onEnded
    />
    {React.array(resultEl)}
  </>
}
