open Promise
open Utils
open Common.Chrome
open Belt.Float

@@warning("-44")

let includeWith = (target, substring) => Js.Re.fromString(substring)->Js.Re.test_(target)
type record = {
  "date": float,
  "text": string,
  @set
  "checked": bool,
  "url": string,
  "title": string,
  "favIconUrl": string,
  "trans": option<resultT>,
}

type return = {
  records: array<record>,
  onCheck: (. record) => unit,
  onSearch: (. string) => unit,
  onDelete: (. array<record>) => unit,
  onClear: (. unit) => unit,
  onCancel: (. unit) => unit,
}
let useRecord = recordType => {
  let (records, setRecords) = React.Uncurried.useState(_ => [])

  let getAll = () => {
    sendMessage(. {_type: Message(recordType, GETALL)})
    ->thenResolve(ret => {
      let rs =
        ret
        ->Js.Array2.sortInPlaceWith((v1, v2) => Belt.Float.toInt(v2["date"] - v1["date"]))
        ->Js.Array2.map(v => {
          v["checked"] = false
          v
        })
      setRecords(._ => rs)
    })
    ->ignore
  }

  React.useEffect1(() => {
    getAll()
    None
  }, [recordType])

  let onSearch = (. val) => {
    if val !== "" {
      let rs = Js.Array2.filter(records, item => {
        item["text"]->includeWith(val)
      })
      setRecords(._ => rs)
    } else {
      getAll()
    }
  }

  let onCheck = (. record) => {
    let rs = Js.Array2.map(records, v => {
      let date = record["date"]
      let checked = record["checked"]

      if date === v["date"] {
        v["checked"] = !checked
      }
      v
    })
    setRecords(._ => rs)
  }

  let onCancel = (. ()) => {
    let rs = Js.Array2.map(records, v => {
      v["checked"] = false
      v
    })
    setRecords(._ => rs)
  }

  let onDelete = (. checkedRecords) => {
    sendMessage(. {
      _type: Message(recordType, DELETE),
      date: Js.Array2.map(checkedRecords, v => v["date"]),
    })
    ->thenResolve(_ => {
      getAll()
    })
    ->ignore
  }

  let onClear = (. ()) => {
    sendMessage(. {_type: Message(recordType, CLEAR)})
    ->thenResolve(_ => {
      getAll()
    })
    ->ignore
  }

  {records, onCheck, onCancel, onClear, onDelete, onSearch}
}
