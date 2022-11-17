open Promise
open Common.Chrome

type loading = Yes | No | Noop

type return = {
  loading: loading,
  errText: string,
  results: Js.Array2.t<{"dst": string, @set "checked": bool}>,
  handleTranslate: (. string) => unit,
}

let useTranslate = () => {
  let (loading, setLoading) = React.Uncurried.useState(_ => Noop)
  let (errText, seErrText) = React.Uncurried.useState(_ => "")
  let (results, setResults) = React.Uncurried.useState(_ => [])

  let handleTranslate = (. text: string) => {
    setLoading(._p => Yes)
    seErrText(._ => "")
    sendMessage(. text)
    ->thenResolve(ret => {
      switch ret {
      | Ok(trans_result) => setResults(._p => trans_result)
      | Error(msg) => seErrText(._p => msg)
      }
      setLoading(._p => No)
    })
    ->ignore
  }

  {loading, errText, results, handleTranslate}
}
