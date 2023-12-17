open TestBinding.Vitest
open TestBinding.ReactTestingLibrary

describe("popup page", () => {
  test("render correctly", () => {
    render(<PopupApp />)->ignore
    let jumpBtn = screen->getByTitle("jump")
    let settingBtn = screen->getByTitle("setting")
    expect(jumpBtn)->toBeInTheDocument
    expect(settingBtn)->toBeInTheDocument
  })
})
