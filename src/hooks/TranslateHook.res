open Utils
open Common.Chrome

type dataT = TResult(resultT) | TLoading(bool) | TError(string) | TNone

let useTranslate = (text: string) => {
  let (data, setData) = React.Uncurried.useState(_ => TNone)

  React.useEffect1(() => {
    let fetchTranslateResult = async txt => {
      if txt !== "" {
        setData(._p => TLoading(true))
        let ret = await sendMessage(TranslateMsgContent({text: txt}))
        let _ = switch ret {
        | Error(msg) => setData(._p => TError(msg))
        | Ok(val) =>
          setData(._p => TResult(val))
          // add history record
          sendMessage(HistoryAddMsgContent({text: txt}))->ignore
        }
      }
    }

    fetchTranslateResult(text)->ignore
    None
  }, [text])

  data
}
