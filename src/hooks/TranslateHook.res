open Utils
open Common.Chrome

type loading = Yes | No | Noop

type return = {
  loading: loading,
  errText: string,
  data: resultT,
}

let useTranslate = (text: string) => {
  let (loading, setLoading) = React.Uncurried.useState(_ => Noop)
  let (errText, seErrText) = React.Uncurried.useState(_ => "")
  let (data, setData) = React.Uncurried.useState(_ => Message(""))

  React.useEffect1(() => {
    let fetchTranslateResult = async txt => {
      if txt !== "" {
        setLoading(._p => Yes)
        seErrText(._ => "")
        let ret = await sendMessage({_type: TRASTALTE, text: txt})
        let _ = switch ret {
        | Message(msg) => seErrText(._p => msg)
        | val => {
            setData(._p => val)
            // add history record
            sendMessage({_type: Message(HISTORY, ADD), text: txt})->ignore
          }
        }
        setLoading(._p => No)
      }
    }

    fetchTranslateResult(text)->ignore
    None
  }, [text])

  {loading, errText, data}
}
