open TestBinding.Vitest
open TestBinding.ReactTestingLibrary
open Fixture

describe("options page", () => {
  beforeAll(() => {
    chromeGetStoreSpy->mockResolvedValue()
  })

  testSkip("render correctly", () => {
    render(<OptionsApp />)->ignore
    let logoTitle = screen->getByText("Love Word")
    expect(logoTitle)->toBeInTheDocument
  })

  test("Shortcut menu", () => {
    render(<Shortcut />)->ignore
    let text = screen->getByText("Assist key")
    expect(text)->toBeInTheDocument
  })
})
