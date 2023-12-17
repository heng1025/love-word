open TestBinding.Vitest
open TestBinding.ReactTestingLibrary
open Fixture

describe("RecordAction component at options page", () => {
  beforeEach(() => {
    render(
      <RecordAction
        records=[dictRecord, baiduRecord]
        onDelete={vi->fn}
        onSync={vi->fn}
        onClear={vi->fn}
        onSearch={vi->fn}
        onCancel={vi->fn}
      />,
    )->ignore
  })

  test("render correctly", () => {
    let actionBtns = screen->getAllByRole("button")
    expect(actionBtns)->toHaveLength(4)
  })
})
