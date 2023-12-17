open TestBinding.Vitest
open TestBinding.ReactTestingLibrary

open Widget

describe("Loading widget", () => {
  test("Loading commponent", async () => {
    render(<Loading delay=150 />)->ignore
    let loading = await screen->findByTestId("loading")
    expect(loading)->toBeInTheDocument
  })
})
