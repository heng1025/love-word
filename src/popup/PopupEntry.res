%%raw("import '../common.css'")

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<PopupApp />, root)
| None => () // do nothing
}
 