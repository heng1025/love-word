open Promise
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
    if text !== "" {
      setLoading(._p => Yes)
      seErrText(._ => "")
      sendMessage(. {_type: Message(HISTORY, ADD), text})->ignore
      sendMessage(. {_type: TRASTALTE, text})
      ->thenResolve(ret => {
        switch ret {
        | Message(msg) => seErrText(. _p => msg)
        | val => setData(. _p => val)
        }
        setLoading(. _p => No)
      })
      ->ignore
    }

    None
  }, [text])

  {loading, errText, data}
}
