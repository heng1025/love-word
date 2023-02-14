open Utils
open Common.Chrome

let includeWith = (target, substring) => Js.Re.fromString(substring)->Js.Re.test_(target)

type return = {
  records: array<recordDataWithExtra>,
  onCheck: (. recordDataWithExtra) => unit,
  onSearch: (. string) => unit,
  onDelete: (. array<recordDataWithExtra>) => unit,
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
    let ret: array<recordDataWithExtra> = await sendMessage(getExtraMsgContent(GetAll))
    let rs =
      ret
      ->Js.Array2.sortInPlaceWith((v1, v2) => Belt.Float.toInt(v2.date) - Belt.Float.toInt(v1.date))
      ->Js.Array2.map(v => {
        ...v,
        checked: false,
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
        item.text->includeWith(val)
      })
      setRecords(._ => rs)
    } else {
      getAll()->ignore
    }
  }

  let onCheck = (. record: recordDataWithExtra) => {
    let rs = Js.Array2.map(records, v => {
      let {date, checked} = record

      if date === v.date {
        v.checked = !checked
      }
      v
    })
    setRecords(._ => rs)
  }

  let onCancel = (. ()) => {
    let rs = Js.Array2.map(records, v => {
      ...v,
      checked: false,
    })
    setRecords(._ => rs)
  }

  let onDelete = async (. checkedRecords) => {
    let _ = await sendMessage(
      getDeleteManyMsgContent({dates: Js.Array2.map(checkedRecords, v => v.date)}),
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
    onSearch,
    onClear: (. ()) => onClear(.)->ignore,
    onDelete: (. args) => onDelete(. args)->ignore,
  }
}
