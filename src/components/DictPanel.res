open Common.Webapi.Window
open TranSource.OfflineDict
open Widget

@react.component
let make = (~data) => {
  let (audio, setAudio) = React.Uncurried.useState(_ => Js.null)
  let (playState, setAudioState) = React.Uncurried.useState(_ => false)
  let trans = Js.Array2.map(Js.String2.split(data.translation, "\n"), v => {
    <p key=v className="mt-[2px]"> {React.string(v)} </p>
  })
  React.useEffect0(() => {
    // type 1 为英音 2 为美音
    let src = `https://dict.youdao.com/dictvoice?audio=${data.word}&type=1`
    let au = createAudio(~url=src, ())
    setAudio(_ => au)

    switch Js.Null.toOption(au) {
    | Some(val) =>
      onEnded(val, () => {
        setAudioState(_p => false)
      })
    | _ => ()
    }

    None
  })

  let play = _ => {
    setAudioState(p => !p)

    switch Js.Null.toOption(audio) {
    | Some(au) => au->playAudio

    | _ => ()
    }
  }
  <div>
    {switch data.phonetic !== "" {
    | true =>
      <div className="inline-flex items-center">
        <span className="mr-2"> {React.string(`[ ${data.phonetic} ]`)} </span>
        <Speaker isPlay=playState onClick=play className="w-5 h-5" />
      </div>
    | _ => React.null
    }}
    <div className="my-2"> {React.array(trans)} </div>
    <div>
      {switch data.tag !== "" {
      | true =>
        React.array(
          Js.Array2.map(Js.String2.split(data.tag, " "), v => {
            <Tag role="mark" key=v className="bg-secondary mr-1 mb-1"> {React.string(v)} </Tag>
          }),
        )
      | _ => React.null
      }}
    </div>
  </div>
}
