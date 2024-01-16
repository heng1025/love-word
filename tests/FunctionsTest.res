open TestBinding.Vitest
open Fixture
open Functions

chromeGetStoreSpy->mockResolvedValue({"user": "iron"})->ignore

describe("Functions module", () => {
  test("includeWith works", () => {
    let res = includeWith("hello", "he")
    expect(res)->toBe(true)
  })

  test("fetchByHttp works", async () => {
    let ret = createMockHttpResponse(~data={"word": "hello"})
    fetchSpy->mockResolvedValue(ret)->ignore
    let res = await fetchByHttp(~url="/dict")
    expect(res)->toStrictEqual(Ok(ret["json"]().data))
  })

  test("fetchByHttp works with error", async () => {
    let ret = createMockHttpResponse(~code=2, ~msg="error")
    fetchSpy->mockResolvedValue(ret)->ignore
    let res = await fetchByHttp(~url="/dict")
    expect(res)->toStrictEqual(Error(ret["json"]().msg))
  })

  testEach((
    {"exn": () => Error.raise(Error.make("js error")), "expected": "js error"},
    {"exn": () => raise(Not_found), "expected": "Unexpected error occurred"},
  ))("fetchByHttp works with $expected  exception", async cases => {
    fetchSpy->mockImplementation(() => cases["exn"]())->ignore
    let res = await fetchByHttp(~url="/dict")
    expect(res)->toStrictEqual(Error(cases["expected"]))
  })

  test("debounce works", () => {
    vi->useFakeTimers->ignore
    let callbackSpy = vi->fn
    let (debouncedFunc, _) = debounce(1000, callbackSpy)

    debouncedFunc()
    expect(callbackSpy)->notAtTest->toHaveBeenCalled()
    vi->runAllTimers->ignore
    expect(callbackSpy)->toHaveBeenCalled()
  })

  test("debounce works with cancel", () => {
    vi->useFakeTimers->ignore
    let callbackSpy = vi->fn
    let (debouncedFunc, cancel) = debounce(1000, callbackSpy)

    debouncedFunc()
    cancel()
    vi->runAllTimers->ignore
    expect(callbackSpy)->notAtTest->toHaveBeenCalled()
  })
})
