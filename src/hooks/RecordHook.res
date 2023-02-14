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

type recordType = History | Favorite

let useRecord = recordType => {
  let (records, setRecords) = React.Uncurried.useState(_ => [])

  let getExtraMsgContent = action => {
    switch recordType {
    | Favorite => FavExtraMsgContent(action)
    | History => HistoryExtraMsgContent(action)
    }
  }
  let getDeleteManyMsgContent = dates => {
    switch recordType {
    | Favorite => FavDeleteManyMsgContent({dates})
    | History => HistoryDeleteManyMsgContent({dates})
    }
  }

  let getAll = async () => {
    let ret = await sendMessage(getExtraMsgContent(GetAll))
    let rs =
      ret
      ->Js.Array2.sortInPlaceWith((v1, v2) => Belt.Float.toInt(v2["date"] - v1["date"]))
      ->Js.Array2.map(v => {
        v["checked"] = false
        v
      })
    setRecords(._ => rs)
  }

  React.useEffect1(() => {
    getAll()->ignore
    None
  }, [recordType])

  let onSearch = (. val) => {
    if val !== "" {
      let rs = Js.Array2.filter(records, item => {
        item["text"]->includeWith(val)
      })
      setRecords(._ => rs)
    } else {
      getAll()->ignore
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

  let onDelete = async (. checkedRecords) => {
    let _ = await sendMessage(
      getDeleteManyMsgContent({dates: Js.Array2.map(checkedRecords, v => v["date"])}),
    )
    await getAll()
  }

  let onClear = async (. ()) => {
    let _ = await sendMessage(getExtraMsgContent(Clear))
    await getAll()
  }

  {
    records,
    onCheck,
    onCancel,
    onClear: (. ()) => onClear(.)->ignore,
    onDelete: (. args) => onDelete(. args)->ignore,
    onSearch,
  }
}
