open TestBinding.Vitest
open TestBinding.ReactTestingLibrary
open Common.Chrome
open TranslateHook

let sendMessageSpy = vi->spyOn(chromeRuntime, "sendMessage")

let initTranslate = (~text="hello") => {
  let hook = renderHook(() => useTranslate(text))
  let result = hook->renderHookResult
  result
}

describe("useTranslate", () => {
  beforeAll(() => {
    sendMessageSpy->mockResolvedValue(Ok("你好"))
  })

  test("tranlate loading status", async () => {
    let result = initTranslate()
    await waitForAtRTL(
      () => {
        let current: return = result->renderHookResultCurrent
        expect(current.loading)->toBe(false)
      },
    )
  })

  test("translate correctly", async () => {
    let result = initTranslate()
    await waitForAtRTL(
      () => {
        let current: return = result->renderHookResultCurrent
        expect(current.data)->toStrictEqual(Ok("你好"))
      },
    )
  })

  test("translate error", async () => {
    sendMessageSpy->mockResolvedValueOnce(Error("error"))->ignore
    let result = initTranslate()
    await waitForAtRTL(
      () => {
        let current: return = result->renderHookResultCurrent
        expect(current.data)->toStrictEqual(Error("error"))
      },
    )
  })

  test("translate source is empty", async () => {
    let result = initTranslate(~text="")
    await waitForAtRTL(
      () => {
        let current: return = result->renderHookResultCurrent
        expect(current.data)->toStrictEqual(None)
      },
    )
  })
})
