open Promise
open Common.Chrome

type loading = Yes | No | Noop

type return<'a> = {
  loading: loading,
  errText: string,
  results: Js.Array2.t<'a>,
}

let useTranslate = (text: string) => {
  let (loading, setLoading) = React.Uncurried.useState(_ => Noop)
  let (errText, seErrText) = React.Uncurried.useState(_ => "")
  let (results, setResults) = React.Uncurried.useState(_ => [])

  React.useEffect1(() => {
    if text !== "" {
      setLoading(._p => Yes)
      seErrText(._ => "")
      sendMessage(. text)
      ->thenResolve(ret => {
        switch ret {
        | Ok(trans_result) => setResults(. _p => trans_result)
        | Error(msg) => seErrText(. _p => msg)
        }
        setLoading(. _p => No)
      })
      ->ignore
    }

    None
  }, [text])

  {loading, errText, results}
}
