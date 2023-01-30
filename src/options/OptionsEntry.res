%%raw("import '../common.css'")

switch ReactDOM.querySelector("#root") {
| Some(rootElement) => {
    let root = ReactDOM.Client.createRoot(rootElement)
    ReactDOM.Client.Root.render(root, <OptionsApp />)
  }

| None => () // do nothing
}
