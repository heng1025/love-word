%%raw("import '../common.css'")

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<OptionsApp />, root)
| None => () // do nothing
}
