open Widget
open Common.Chrome
open Utils

@react.component
let make = (~text, ~trans) => {
  let (isFaved, setFaved) = React.Uncurried.useState(_ => false)

  let favAction = async action => {
    if text !== "" {
      let faved = await sendMessage({_type: Message(FAVORITE, action), text, trans})
      setFaved(._ => faved)
    }
  }

  React.useEffect1(() => {
    favAction(GET)->ignore

    None
  }, [text])

  <button
    className="btn btn-xs w-5 h-5 fill-white min-h-0 btn-circle btn-ghost"
    onClick={_ => favAction(isFaved ? DELETE : ADD)->ignore}>
    {switch isFaved {
    | false => <Star />
    | true => <StarFill />
    }}
  </button>
}
