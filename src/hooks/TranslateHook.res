open Utils
open Common.Chrome

type return = {
  loading: bool,
  data: option<transRWithError>,
}

let useTranslate = (text: string) => {
  let (loading, setLoading) = React.Uncurried.useState(_ => false)
  let (data, setData) = React.Uncurried.useState(_ => None)

  React.useEffect1(() => {
    let fetchTranslateResult = async txt => {
      if txt !== "" {
        setLoading(_p => true)
        let ret: transRWithError =
          await chromeRuntime->sendMessage(TranslateMsgContent({text: txt}))
        let _ = switch ret {
        | Error(msg) => setData(_p => Some(Error(msg)))
        | Ok(val) =>
          setData(_p => Some(Ok(val)))
          // add history record
          chromeRuntime->sendMessage(HistoryAddMsgContent({text: txt}))->ignore
        }
        setLoading(_p => false)
      }
    }

    fetchTranslateResult(text)->ignore

    Some(() => setData(_p => None))
  }, [text])

  {loading, data}
}
