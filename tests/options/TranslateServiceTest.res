open TestBinding.Vitest
open TestBinding.ReactTestingLibrary
open Fixture

let _ = TranSource.Baidu.translate

// Type Cast (mock)
@val external baiduTranslateMock: mockInstance = "TranSource.Baidu.translate"

// just mock `Baidu.translate``
let factory = async importOriginal => {
  let mod = await importOriginal()
  let copy = Js.Obj.assign(Js.Obj.empty(), mod)
  copy["Baidu"]["translate"] = vi->fn
  copy
}

vi->mock("../../src/TranSource.js", ~factory)

let openIdConfig = {
  "appid": "testAppid",
  "secret": "testSecret",
}

describe("TranslateService in options page", () => {
  beforeAll(() => {
    chromeGetStoreSpy->mockResolvedValue({"baiduKey": openIdConfig})
  })

  test("render correctly", async () => {
    render(<TranslateService />)->ignore
    let appidLabel = await screen->findByText("baidu appid")
    let secretLabel = await screen->findByText("baidu secret")

    expect(appidLabel)->toBeInTheDocument
    expect(secretLabel)->toBeInTheDocument
  })

  test("appid input value change", async () => {
    render(<TranslateService />)->ignore
    let appidInput = await screen->findByPlaceholderText("Appid")
    expect(appidInput)->toHaveValue(openIdConfig["appid"])

    let user = userEvent->setup
    await user->clear(appidInput)
    await user->type_(appidInput, "abcd")
    expect(appidInput)->toHaveValue("abcd")
  })

  test("secret input value change", async () => {
    render(<TranslateService />)->ignore
    let secretInput = await screen->findByPlaceholderText("Secret")
    expect(secretInput)->toHaveValue(openIdConfig["secret"])

    let user = userEvent->setup
    await user->clear(secretInput)
    await user->type_(secretInput, "1234")
    expect(secretInput)->toHaveValue("1234")
  })

  test("secret input value can be seen", async () => {
    render(<TranslateService />)->ignore
    let eyeSplashIcon = screen->getByTitle("eyeSlash")

    let user = userEvent->setup
    await user->click(eyeSplashIcon)
    let eyeIcon = screen->getByTitle("eye")
    expect(eyeIcon)->toBeInTheDocument
    expect(eyeSplashIcon)->notAtTest->toBeInTheDocument
  })

  test("save appid/secret success", async () => {
    chromeSetStoreSpy->mockResolvedValue()->ignore
    baiduTranslateMock->mockResolvedValue(Ok("success"))->ignore
    render(<TranslateService />)->ignore
    let submitBtn = screen->getByRole("button", ~opts={"name": "Submit"})
    let user = userEvent->setup
    await user->click(submitBtn)
    expect(submitBtn)->toHaveClass("btn-disabled")
  })

  test("save appid/secret fail with alert message", async () => {
    chromeSetStoreSpy->mockResolvedValue()->ignore
    baiduTranslateMock->mockResolvedValue(Error("ops"))->ignore
    render(<TranslateService />)->ignore
    let submitBtn = screen->getByRole("button", ~opts={"name": "Submit"})
    let user = userEvent->setup
    await user->click(submitBtn)
    let alertIcon = await screen->findByTitle("alert")
    expect(alertIcon)->toBeInTheDocument
  })
})
