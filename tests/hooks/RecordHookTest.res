open TestBinding.Vitest
open TestBinding.ReactTestingLibrary
open Common.Chrome
open Fixture
open RecordHook
open Utils

let wordRecords = [dictRecord, baiduRecord]
let sendMessageSpy = vi->spyOn(chromeRuntime, "sendMessage")

let initRecords = recordType => {
  let hook = renderHook(() => useRecord(recordType))
  let result = hook->renderHookResult
  result
}

// %s => string, %i => int, %f => float
describeEach([Favorite, History])("useRecordHook works for %s", recordType => {
  beforeAll(() => {
    sendMessageSpy->mockResolvedValue(wordRecords)
  })
  afterAll(() => {
    vi->clearAllMocks
  })

  test("get all favorite records", async () => {
    let result = initRecords(recordType)

    await waitForAtRTL(
      () => {
        // latest records
        let current: return = result->renderHookResultCurrent
        expect(current.records)->toStrictEqual(wordRecords)
      },
    )
  })

  test("search records without keyword", async () => {
    let result = initRecords(recordType)

    act(
      () => {
        let current: return = result->renderHookResultCurrent
        current.onSearch("")
      },
    )
    // await again for getAll
    await waitForAtRTL(
      () => {
        let current: return = result->renderHookResultCurrent
        expect(current.records)->toHaveLength(2)
        expect(current.records)->toStrictEqual(wordRecords)
      },
    )
  })

  test("seach records with results", async () => {
    let result = initRecords(recordType)
    await waitForAtRTL(() => None)

    act(
      () => {
        let current: return = result->renderHookResultCurrent
        current.onSearch("hello")
      },
    )

    let current: return = result->renderHookResultCurrent
    expect(current.records)->toHaveLength(1)
  })

  test("seach records without results", async () => {
    let result = initRecords(recordType)
    await waitForAtRTL(() => None)

    act(
      () => {
        let current: return = result->renderHookResultCurrent
        current.onSearch("abc")
      },
    )
    let current: return = result->renderHookResultCurrent
    expect(current.records)->toHaveLength(0)
  })

  test("check records", async () => {
    let result = initRecords(recordType)
    await waitForAtRTL(() => None)

    act(
      () => {
        let current: return = result->renderHookResultCurrent
        current.onCheck(dictRecord)
      },
    )

    let current: return = result->renderHookResultCurrent
    let checkedRecords = current.records->Array.filter(r => r.checked)
    expect(checkedRecords)->toHaveLength(1)
    expect((checkedRecords->Array.getUnsafe(0)).text)->toBe(dictRecord.text)
  })

  test("cancle checked", async () => {
    let result = initRecords(recordType)

    act(
      () => {
        let current = result->renderHookResultCurrent
        current.onCancel()
      },
    )

    await waitForAtRTL(
      () => {
        let current: return = result->renderHookResultCurrent
        let isAllUnchecked = current.records->Array.every(r => r.checked === false)
        expect(isAllUnchecked)->toBe(true)
      },
    )
  })

  test("delete records", async () => {
    let result = initRecords(recordType)

    act(
      () => {
        sendMessageSpy->mockResolvedValue([baiduRecord])->ignore
        let current: return = result->renderHookResultCurrent
        current.onDelete([{...dictRecord, checked: true}])
      },
    )

    await waitForAtRTL(
      () => {
        let current: return = result->renderHookResultCurrent
        expect(current.records)->toHaveLength(1)
      },
    )
  })

  test("clear records", async () => {
    let result = initRecords(recordType)

    act(
      () => {
        sendMessageSpy->mockResolvedValue([])->ignore
        let current: return = result->renderHookResultCurrent
        current.onClear()
      },
    )

    await waitForAtRTL(
      () => {
        let current: return = result->renderHookResultCurrent
        expect(current.records)->toHaveLength(0)
      },
    )
  })

  test("sync records", async () => {
    let result = initRecords(recordType)

    act(
      () => {
        let updatedRecords = [{...dictRecord, sync: true, checked: true}, baiduRecord]
        sendMessageSpy->mockResolvedValue(updatedRecords)->ignore
        let current: return = result->renderHookResultCurrent
        current.onSync([{...dictRecord, checked: true}])
      },
    )

    await waitForAtRTL(
      () => {
        let current: return = result->renderHookResultCurrent
        let syncedRecords = current.records->Array.filter(r => r.sync)
        expect(syncedRecords)->toHaveLength(1)
        expect((syncedRecords->Array.getUnsafe(0)).text)->toBe(dictRecord.text)
      },
    )
  })
})
