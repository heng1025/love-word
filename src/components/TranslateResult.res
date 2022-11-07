open Utils

@react.component
let make = (~loading, ~errText, ~results, ~className) => {
  <div className>
    {switch loading {
    | Yes => <div> {React.string("loading...")} </div>
    | No =>
      switch errText !== "" {
      | true => <div> {React.string(errText)} </div>
      | false =>
        React.array(
          Js.Array2.mapi(results, (result, idx) => {
            <p key={Js.Int.toString(idx)}> {React.string(result["dst"])} </p>
          }),
        )
      }
    | Noop => React.null
    }}
  </div>
}
