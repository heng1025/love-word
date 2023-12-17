open TestBinding.Vitest
open TestBinding.ReactTestingLibrary
open Fixture

let _ = RecordHook.useRecord

// Type Cast (mock)
@val external useRecordMock: mockInstance = "RecordHook.useRecord"

vi->mock("../../src/hooks/RecordHook.js")

let mockUserRecordData = {
  "records": [dictRecord, baiduRecord],
  "onCheck": vi->fn,
  "onCancel": vi->fn,
  "onClear": vi->fn,
  "onDelete": vi->fn,
  "onSync": vi->fn,
  "onSearch": vi->fn,
}

useRecordMock->mockReturnValue(mockUserRecordData)

describe("History in options page", () => {
  test("render correctly", async () => {
    render(<Favorite />)->ignore

    let transWraps = await screen->findAllByTestId("transWrap")
    expect(transWraps)->toHaveLength(2)
  })

  testTodo("check")
  testTodo("sync")
  testTodo("delete")
  testTodo("clear")
})
