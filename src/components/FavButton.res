open Promise
open Widget
open Common.Chrome
open Utils

@react.component
let make = (~text, ~trans) => {
  let (isFaved, setFaved) = React.Uncurried.useState(_ => false)

  let favAction = action => {
    if text !== "" {
      sendMessage(. {_type: Message(FAVORITE, action), text, trans})
      ->then(faved => {
        setFaved(._ => faved)

        resolve()
      })
      ->ignore
    }
  }

  React.useEffect1(() => {
    favAction(GET)
    None
  }, [text])

  <button
    className="btn btn-xs w-5 h-5 fill-white min-h-0 btn-circle btn-ghost"
    onClick={_ => favAction(isFaved ? DELETE : ADD)}>
    {switch isFaved {
    | false => <Star />
    | true => <StarFill />
    }}
  </button>
}
