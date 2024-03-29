open Utils
open Common.Chrome
open Functions

type return = {
  records: array<recordDataWithExtra>,
  onCheck: recordDataWithExtra => unit,
  onSearch: string => unit,
  onSync: array<recordDataWithExtra> => unit,
  onDelete: array<recordDataWithExtra> => unit,
  onClear: unit => unit,
  onCancel: unit => unit,
}

let useRecord = recordType => {
  let (records, setRecords) = React.Uncurried.useState(_ => [])

  let getExtraMsgContent = action => {
    switch recordType {
    | Favorite => FavExtraMsgContent(action)
    | History => HistoryExtraMsgContent(action)
    }
  }
  let getDeleteManyMsgContent = records => {
    switch recordType {
    | Favorite => FavDeleteManyMsgContent({records})
    | History => HistoryDeleteManyMsgContent({records})
    }
  }

  let getAddManyMsgContent = records => {
    switch recordType {
    | Favorite => FavAddManyMsgContent({records})
    | History => HistoryAddManyMsgContent({records})
    }
  }

  let getAll = async () => {
    let ret: array<recordDataWithExtra> =
      await chromeRuntime->sendMessage(getExtraMsgContent(GetAll))
    ret->Array.sort((v1, v2) => v2.date -. v1.date)
    let rs = ret->Array.map(v => {
      ...v,
      checked: false,
    })
    setRecords(_ => rs)
  }

  React.useEffect(() => {
    getAll()->ignore
    None
  }, [recordType])

  let onSearch = val => {
    if val !== "" {
      let rs = records->Array.filter(item => {
        item.text->includeWith(val)
      })
      setRecords(_ => rs)
    } else {
      getAll()->ignore
    }
  }

  let onCheck = (record: recordDataWithExtra) => {
    let rs = Array.map(records, v => {
      let {date, checked} = record

      if date === v.date {
        v.checked = !checked
      }
      v
    })
    setRecords(_ => rs)
  }

  let onCancel = () => {
    let rs = Array.map(records, v => {
      ...v,
      checked: false,
    })
    setRecords(_ => rs)
  }

  let onDelete = async checkedRecords => {
    let _ = await chromeRuntime->sendMessage(
      getDeleteManyMsgContent({
        records: Array.map(checkedRecords, v => {text: v.text, date: v.date}),
      }),
    )
    await getAll()
  }

  let onSync = async checkedRecords => {
    let _ = await chromeRuntime->sendMessage(getAddManyMsgContent(checkedRecords))
    await getAll()
  }

  let onClear = async () => {
    let _ = await chromeRuntime->sendMessage(getExtraMsgContent(Clear))
    await getAll()
  }

  {
    records,
    onCheck,
    onCancel,
    onSearch,
    onClear: () => onClear()->ignore,
    onDelete: args => onDelete(args)->ignore,
    onSync: args => onSync(args)->ignore,
  }
}
