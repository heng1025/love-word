open Utils
open Common.Chrome

type dataT = TResult(transRWithError) | TNone

type return = {
  loading: bool,
  data: dataT,
}

let useTranslate = (text: string) => {
  let (loading, setLoading) = React.Uncurried.useState(_ => false)
  let (data, setData) = React.Uncurried.useState(_ => TNone)

  React.useEffect1(() => {
    let fetchTranslateResult = async txt => {
      if txt !== "" {
        setLoading(._p => true)
        let ret: transRWithError = await sendMessage(TranslateMsgContent({text: txt}))
        let _ = switch ret {
        | Error(msg) => setData(._p => TResult(Error(msg)))
        | Ok(val) =>
          setData(._p => TResult(Ok(val)))
          // add history record
          sendMessage(HistoryAddMsgContent({text: txt}))->ignore
        }
        setLoading(._p => false)
      }
    }

    fetchTranslateResult(text)->ignore

    None
  }, [text])

  {loading, data}
}
