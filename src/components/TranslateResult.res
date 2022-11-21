open Utils
open Common.Webapi
open TranslateHook

@react.component
let make = (~loading, ~errText, ~results, ~className) => {
  let audioEl = React.useRef(Js.Nullable.null)
  let (transList, setTransList) = React.Uncurried.useState(_ => [])

  React.useEffect1(() => {
    setTransList(._ =>
      Js.Array2.map(
        results,
        v => {
          v["isPlay"] = false
          v["sourceVisible"] = false
          v
        },
      )
    )
    None
  }, [results])

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
  <div className={`${className} lw-scroll-wrap max-h-52 overflow-y-auto overscroll-contain`}>
    <audio ref={ReactDOM.Ref.domRef(audioEl)} className="w-full h-8 mb-1" onEnded />
    {switch loading {
    | Yes => <div> {React.string("loading...")} </div>
    | No =>
      switch errText !== "" {
      | true => <div> {React.string(errText)} </div>
      | false =>
        React.array(
          Js.Array2.mapi(transList, (result, idx) => {
            let text = result["sourceVisible"] ? result["src"] : result["dst"]
            let isPlay = result["isPlay"]
            // https://tailwindcss.com/docs/content-configuration#class-detection-in-depth
            let animate200ms = isPlay ? "animate-fadeInOut-200ms" : ""
            let animate400ms = isPlay ? "animate-fadeInOut-400ms" : ""
            <p key={Js.Int.toString(idx)}>
              <span className="align-middle"> {React.string(text)} </span>
              <button
                className="btn btn-xs w-5 h-5 min-h-0 btn-circle btn-ghost ml-[2px] align-middle"
                onClick={_ => toggleSource(text)}>
                {switch result["sourceVisible"] {
                | true =>
                  <svg
                    className="fill-warning"
                    viewBox="0 0 1024 1024"
                    xmlns="http://www.w3.org/2000/svg">
                    <path
                      d="M941.677 370.37666667c9.338-14.006 6.225-32.681-6.225-43.575-14.006-10.894-32.681-7.781-43.575 6.225-1.557 1.556-174.3 205.426-379.728 205.426-199.2 0-379.727-205.426-381.283-206.982-10.895-12.45-31.125-14.006-43.576-3.113-12.45 10.894-14.006 31.125-3.113 43.576 3.113 4.668 40.463 46.687 99.6 93.375l-79.37 82.482c-12.45 12.45-10.893 32.681 1.557 43.575 3.113 6.225 10.894 9.338 18.676 9.338 7.78 0 15.562-3.113 21.787-9.338l85.594-88.706c40.463 28.013 88.707 54.47 141.62 73.144l-32.682 110.495c-4.668 17.118 4.67 34.237 21.788 38.906h9.337c14.006 0 26.457-9.338 29.569-23.344l32.681-110.495c24.9 4.669 51.357 7.782 77.813 7.782s52.913-3.113 77.814-7.782l32.68 108.939c3.114 14.006 17.12 23.343 29.57 23.343 3.113 0 6.225 0 7.782-1.556 17.118-4.67 26.456-21.787 21.788-38.906L649.099 574.24666667c52.914-18.676 101.157-45.132 141.62-73.144l84.038 87.15c6.225 6.225 14.006 9.338 21.787 9.338 7.781 0 15.563-3.113 21.787-9.337 12.45-12.451 12.45-31.125 1.557-43.576l-79.37-82.481c63.808-46.689 101.16-91.82 101.16-91.82z"
                    />
                  </svg>

                | false =>
                  <svg
                    className="fill-warning"
                    viewBox="0 0 1024 1024"
                    xmlns="http://www.w3.org/2000/svg">
                    <path
                      d="M512 272.9375C219.0640625 272.9375 72.8140625 487.278125 66.725 496.4046875c-6.3 9.45-6.3 21.7546875 0 31.2046875C72.8140625 536.721875 219.0640625 751.0625 512 751.0625s439.1859375-214.340625 445.275-223.4671875c6.3-9.45 6.3-21.7546875 0-31.2046875C951.1859375 487.278125 804.9359375 272.9375 512 272.9375zM512 694.8125C293.9328125 694.8125 163.728125 558.715625 125.45 511.94375 163.6015625 465.0734375 293.13125 329.1875 512 329.1875c218.0671875 0 348.271875 136.096875 386.55 182.86875C860.3984375 558.9265625 730.86875 694.8125 512 694.8125zM512 385.4375c-69.7921875 0-126.5625 56.784375-126.5625 126.5625s56.7703125 126.5625 126.5625 126.5625 126.5625-56.784375 126.5625-126.5625S581.7921875 385.4375 512 385.4375zM512 582.3125c-38.7703125 0-70.3125-31.5421875-70.3125-70.3125s31.5421875-70.3125 70.3125-70.3125 70.3125 31.5421875 70.3125 70.3125S550.7703125 582.3125 512 582.3125z"
                    />
                  </svg>
                }}
              </button>
              <button
                className="btn btn-xs w-5 h-5 min-h-0 btn-circle btn-ghost ml-[2px] align-middle inline-flex"
                onClick={_ => onPlay(text)}>
                <svg
                  className="fill-warning"
                  viewBox="0 0 1024 1024"
                  version="1.1"
                  xmlns="http://www.w3.org/2000/svg">
                  <path
                    d="M610.87695313 256.56787084c0-35.56274388-41.98974585-54.38232422-68.55468776-30.7836909L394.23754883 357.38940455a24.71923828 24.71923828 0 0 1-16.41357422 6.26220652H256.56787084A74.15771484 74.15771484 0 0 0 182.410156 437.80932592v148.21655273a74.15771484 74.15771484 0 0 0 74.15771484 74.15771484h121.28906301a24.71923828 24.71923828 0 0 1 16.41357422 6.26220729l148.01879882 131.63818385c26.56494115 23.59863255 68.58764623 4.74609375 68.58764624-30.78369167V256.56787084zM427.13061498 394.33642578L561.43847655 274.92602563v474.01611329l-134.30786157-119.44335937a74.15771484 74.15771484 0 0 0-49.27368113-18.75366263H256.56787084a24.71923828 24.71923828 0 0 1-24.71923827-24.71923827V437.84228516a24.71923828 24.71923828 0 0 1 24.71923827-24.71923829h121.28906301a74.15771484 74.15771484 0 0 0 49.27368113-18.75366185z"
                  />
                  <path
                    className=animate200ms
                    d="M681.50805689 392.35888672a24.71923828 24.71923828 0 0 1 33.51928711 9.95361303c17.66601537 32.62939453 27.68554688 70.03784205 27.68554688 109.68750025a229.8229983 229.8229983 0 0 1-27.68554688 109.68750025 24.71923828 24.71923828 0 0 1-43.50585937-23.53271484c13.84277344-25.60913086 21.75292969-54.90966822 21.7529297-86.15478541s-7.91015625-60.54565455-21.7529297-86.15478541a24.71923828 24.71923828 0 0 1 9.98657226-33.51928711z"
                  />
                  <path
                    className=animate400ms
                    d="M742.4492185 310.85131811a24.71923828 24.71923828 0 0 1 34.57397511 5.1745608A328.23852514 328.23852514 0 0 1 841.589844 512a328.27148438 328.27148438 0 0 1-64.59960962 195.97412109 24.71923828 24.71923828 0 0 1-39.71557592-29.39941431A278.80004858 278.80004858 0 0 0 792.15136743 512a278.80004858 278.80004858 0 0 0-54.87670897-166.57470678 24.71923828 24.71923828 0 0 1 5.17456004-34.57397511z"
                  />
                </svg>
              </button>
            </p>
          }),
        )
      }
    | Noop => React.null
    }}
  </div>
}
