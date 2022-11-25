open Utils.OfflineDict
open Widget

@react.component
let make = (~data) => {
  let trans = Js.Array2.map(Js.String2.split(data.translation, "\n"), v => {
    <p key=v className="mt-[2px]"> {React.string(v)} </p>
  })

  <div>
    {switch data.phonetic !== "" {
    | true => <p> {React.string(`[ ${data.phonetic} ]`)} </p>
    | _ => React.null
    }}
    <div className="my-2"> {React.array(trans)} </div>
    <div>
      {switch data.tag !== "" {
      | true =>
        React.array(
          Js.Array2.map(Js.String2.split(data.tag, " "), v => {
            <Tag key=v className="bg-secondary mr-1 mb-1"> {React.string(v)} </Tag>
          }),
        )
      | _ => React.null
      }}
    </div>
  </div>
}
