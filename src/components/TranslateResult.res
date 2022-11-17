open Utils
open Common.Webapi
open TranslateHook

@react.component
let make = (~loading, ~errText, ~results, ~className) => {
  let audioEl = React.useRef(Js.Nullable.null)
  let onPlay = source => {
    audioEl.current
    ->Js.Nullable.toOption
    ->Belt.Option.forEach(audio => {
      audio->Element.createAudioSrc(source)
      audio->Element.play
    })
  }

  <div className>
    <audio ref={ReactDOM.Ref.domRef(audioEl)} />
    {switch loading {
    | Yes => <div> {React.string("loading...")} </div>
    | No =>
      switch errText !== "" {
      | true => <div> {React.string(errText)} </div>
      | false =>
        React.array(
          Js.Array2.mapi(results, (result, idx) => {
            <p key={Js.Int.toString(idx)}>
              <span className="align-middle"> {React.string(result["dst"])} </span>
              <button
                className="btn btn-xs btn-circle btn-ghost ml-1 align-middle "
                onClick={_ => onPlay(Baidu.textToSpeech(result["dst"]))}>
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  className="h-5 w-5 fill-warning"
                  fill="currentColor"
                  viewBox="0 0 1024 1024">
                  <path
                    d="M640 181.333333c0-46.037333-54.357333-70.4-88.746667-39.850666L359.552 311.850667a32 32 0 0 1-21.248 8.106666H181.333333A96 96 0 0 0 85.333333 415.957333v191.872a96 96 0 0 0 96 96h157.013334a32 32 0 0 1 21.248 8.106667l191.616 170.410667c34.389333 30.549333 88.789333 6.144 88.789333-39.850667V181.333333zM402.133333 359.68L576 205.098667v613.632l-173.866667-154.624a96 96 0 0 0-63.786666-24.277334H181.333333a32 32 0 0 1-32-32V416a32 32 0 0 1 32-32h157.013334a96 96 0 0 0 63.786666-24.277333z"
                  />
                  <path
                    d="M731.434667 357.12a32 32 0 0 1 43.392 12.885333c22.869333 42.24 35.84 90.666667 35.84 141.994667a297.514667 297.514667 0 0 1-35.84 141.994667 32 32 0 0 1-56.32-30.464c17.92-33.152 28.16-71.082667 28.16-111.530667s-10.24-78.378667-28.16-111.530667a32 32 0 0 1 12.928-43.392z"
                  />
                  <path
                    d="M810.325333 251.605333a32 32 0 0 1 44.757334 6.698667A424.917333 424.917333 0 0 1 938.666667 512a424.96 424.96 0 0 1-83.626667 253.696 32 32 0 0 1-51.413333-38.058667A360.917333 360.917333 0 0 0 874.666667 512a360.917333 360.917333 0 0 0-71.04-215.637333 32 32 0 0 1 6.698666-44.757334z"
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
