open Utils
open Widget
open Common.Webapi

@react.component
let make = (~data) => {
  let audioEl = React.useRef(Js.Nullable.null)
  let (transList, setTransList) = React.Uncurried.useState(_ => [])

  React.useEffect1(() => {
    setTransList(._ =>
      Js.Array2.map(
        data,
        v => {
          v["isPlay"] = false
          v["sourceVisible"] = false
          v
        },
      )
    )
    None
  }, [data])

  let onPlay = text => {
    setTransList(.p =>
      Js.Array2.map(p, v => {
        // https://forum.rescript-lang.org/t/object-access-using-variable/593/2
        if v["src"] === text || v["dst"] === text {
          v["isPlay"] = !v["isPlay"]
        } else {
          v["isPlay"] = false
        }
        v
      })
    )

    audioEl.current
    ->Js.Nullable.toOption
    ->Belt.Option.forEach(audio => {
      let current = Js.Array2.find(transList, v => v["src"] === text || v["dst"] === text)
      switch current {
      | Some(v) =>
        if v["isPlay"] {
          audio->Element.createAudioSrc("")
        } else {
          audio->Element.createAudioSrc(Baidu.textToSpeech(text))
          audio->Element.play
        }
      | _ => ()
      }
    })
  }

  let onEnded = _ => {
    setTransList(.p =>
      Js.Array2.map(p, v => {
        v["isPlay"] = false
        v
      })
    )
  }

  let toggleSource = text => {
    setTransList(.p =>
      Js.Array2.map(p, v => {
        if v["src"] === text || v["dst"] === text {
          v["sourceVisible"] = !v["sourceVisible"]
        }
        v
      })
    )
  }

  let resultEl = Js.Array2.mapi(transList, (result, idx) => {
    let text = result["sourceVisible"] ? result["src"] : result["dst"]
    let isPlay = result["isPlay"]
    <p key={Js.Int.toString(idx)}>
      <span className="align-middle"> {React.string(text)} </span>
      <button
        className="btn btn-xs w-5 h-5 min-h-0 btn-circle btn-ghost ml-[2px] align-middle"
        onClick={_ => toggleSource(text)}>
        {switch result["sourceVisible"] {
        | true =>
          <svg className="fill-warning" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M941.677 370.37666667c9.338-14.006 6.225-32.681-6.225-43.575-14.006-10.894-32.681-7.781-43.575 6.225-1.557 1.556-174.3 205.426-379.728 205.426-199.2 0-379.727-205.426-381.283-206.982-10.895-12.45-31.125-14.006-43.576-3.113-12.45 10.894-14.006 31.125-3.113 43.576 3.113 4.668 40.463 46.687 99.6 93.375l-79.37 82.482c-12.45 12.45-10.893 32.681 1.557 43.575 3.113 6.225 10.894 9.338 18.676 9.338 7.78 0 15.562-3.113 21.787-9.338l85.594-88.706c40.463 28.013 88.707 54.47 141.62 73.144l-32.682 110.495c-4.668 17.118 4.67 34.237 21.788 38.906h9.337c14.006 0 26.457-9.338 29.569-23.344l32.681-110.495c24.9 4.669 51.357 7.782 77.813 7.782s52.913-3.113 77.814-7.782l32.68 108.939c3.114 14.006 17.12 23.343 29.57 23.343 3.113 0 6.225 0 7.782-1.556 17.118-4.67 26.456-21.787 21.788-38.906L649.099 574.24666667c52.914-18.676 101.157-45.132 141.62-73.144l84.038 87.15c6.225 6.225 14.006 9.338 21.787 9.338 7.781 0 15.563-3.113 21.787-9.337 12.45-12.451 12.45-31.125 1.557-43.576l-79.37-82.481c63.808-46.689 101.16-91.82 101.16-91.82z"
            />
          </svg>

        | false =>
          <svg className="fill-warning" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M512 272.9375C219.0640625 272.9375 72.8140625 487.278125 66.725 496.4046875c-6.3 9.45-6.3 21.7546875 0 31.2046875C72.8140625 536.721875 219.0640625 751.0625 512 751.0625s439.1859375-214.340625 445.275-223.4671875c6.3-9.45 6.3-21.7546875 0-31.2046875C951.1859375 487.278125 804.9359375 272.9375 512 272.9375zM512 694.8125C293.9328125 694.8125 163.728125 558.715625 125.45 511.94375 163.6015625 465.0734375 293.13125 329.1875 512 329.1875c218.0671875 0 348.271875 136.096875 386.55 182.86875C860.3984375 558.9265625 730.86875 694.8125 512 694.8125zM512 385.4375c-69.7921875 0-126.5625 56.784375-126.5625 126.5625s56.7703125 126.5625 126.5625 126.5625 126.5625-56.784375 126.5625-126.5625S581.7921875 385.4375 512 385.4375zM512 582.3125c-38.7703125 0-70.3125-31.5421875-70.3125-70.3125s31.5421875-70.3125 70.3125-70.3125 70.3125 31.5421875 70.3125 70.3125S550.7703125 582.3125 512 582.3125z"
            />
          </svg>
        }}
      </button>
      <Speaker isPlay onClick={_ => onPlay(text)} />
    </p>
  })

  <>
    <audio ref={ReactDOM.Ref.domRef(audioEl)} className="w-full h-8 mb-1" onEnded />
    {React.array(resultEl)}
  </>
}
