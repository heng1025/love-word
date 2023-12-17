open TestBinding.Vitest
open TestBinding.ReactTestingLibrary
open TranslateResult
open Utils
open Fixture

describe("StatelessTPanel component", () => {
  test("show dict panel", () => {
    let wrapper = render(<StatelessTPanel data=DictT(dictData) />)
    let phonetic = screen->getByText("[ hә'lәu ]")
    let transWrap = screen->getByTestId("transWrap")
    expect(phonetic)->toBeInTheDocument
    expect(transWrap)->notAtTest->toHaveClass("my-text-sm")
    wrapper->rerender(<StatelessTPanel data=DictT(dictData) className="my-text-sm" />)
    expect(transWrap)->toHaveClass("my-text-sm")
  })

  test("show machine translate panel", () => {
    render(<StatelessTPanel data=BaiduT(baiduData) />)->ignore
    let translation = screen->getByText("hello")
    expect(translation)->toBeInTheDocument
  })
})

describe("TranslateResult component", () => {
  test("show loading panel", async () => {
    render(<TranslateResult loading=true delay=150 data=None />)->ignore
    let loading = await screen->findByTestId("loading")
    expect(loading)->toBeInTheDocument
  })

  test("show translate error message", async () => {
    let data = Some(Error("error"))
    render(<TranslateResult loading=true delay=150 data />)->ignore
    let alert = screen->getByRole("alert")
    expect(alert)->toHaveClass("text-error")
  })

  test("show empty translate result", () => {
    let data = Some(Ok(Js.Nullable.null))
    render(<TranslateResult data />)->ignore
    let empty = screen->getByText("No translation")
    expect(empty)->toBeInTheDocument
  })

  test("show correct translate result", () => {
    let wrapperBaiduData = Some(Ok(Js.Nullable.return(BaiduT(baiduData))))
    let wrapper = render(<TranslateResult data=wrapperBaiduData />)
    let empty = screen->getByText("hello")
    expect(empty)->toBeInTheDocument
    let transWrap = screen->getByTestId("transWrap")
    expect(transWrap)->notAtTest->toHaveClass("my-text-sm")
    wrapper->rerender(<TranslateResult data=wrapperBaiduData className="my-text-sm" />)
    expect(transWrap)->toHaveClass("my-text-sm")
  })
})
