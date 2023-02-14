open Widget
open Common.Chrome
open Utils

type action = Get | Add | Delete
@react.component
let make = (~text, ~trans) => {
  let (isFaved, setFaved) = React.Uncurried.useState(_ => false)

  let favAction = async action => {
    let msgContent = switch action {
    | Get => FavGetOneMsgContent({text: text})
    | Add => FavAddMsgContent({text, trans})
    | Delete => FavDeleteOneMsgContent({text: text})
    }
    if text !== "" {
      let faved = await sendMessage(msgContent)
      setFaved(._ => faved)
    }
  }

  React.useEffect1(() => {
    favAction(Get)->ignore

    None
  }, [text])

  <button
    className="btn btn-xs w-5 h-5 fill-white min-h-0 btn-circle btn-ghost"
    onClick={_ => favAction(isFaved ? Delete : Add)->ignore}>
    {switch isFaved {
    | false => <Star />
    | true => <StarFill />
    }}
  </button>
}
