open TestBinding.Vitest
open Utils
open Fixture

// just use for import some module in js file
let {createFranc} = module(Common.FrancMin)
let _createMd5 = Common.Md5.createMd5

// Type Cast (mock)
@val external francMock: mockInstance = "FrancMin.franc"
@val external md5Mock: mockInstance = "Md5"

vi->mock("franc-min")
vi->mock("md5")

exception Unknown(string)
let mockChromeStore = {
  "user": "iron",
  "baiduKey": {
    "appid": "testAppid",
    "secret": "testSecret",
  },
}

chromeGetStoreSpy->mockResolvedValue(mockChromeStore)->ignore

let libSuite = () => {
  test("fetchByHttp works", async () => {
    let ret = createMockHttpResponse(~data={"word": "hello"})
    fetchSpy->mockResolvedValue(ret)->ignore
    let res = await Lib.fetchByHttp(~url="/dict")
    expect(res)->toStrictEqual(Ok(ret["json"]().data))
  })

  test("fetchByHttp works with error", async () => {
    let ret = createMockHttpResponse(~code=2, ~msg="error")
    fetchSpy->mockResolvedValue(ret)->ignore
    let res = await Lib.fetchByHttp(~url="/dict")
    expect(res)->toStrictEqual(Error(ret["json"]().msg))
  })

  testEach((
    {"exn": () => Js.Exn.raiseError("js error"), "expected": "js error"},
    {"exn": () => raise(Not_found), "expected": "Unexpected error occurred"},
  ))("fetchByHttp works with $expected  exception", async cases => {
    fetchSpy->mockImplementation(() => cases["exn"]())->ignore
    let res = await Lib.fetchByHttp(~url="/dict")
    expect(res)->toStrictEqual(Error(cases["expected"]))
  })

  test("debounce works", () => {
    vi->useFakeTimers->ignore
    let callbackSpy = vi->fn
    let (debouncedFunc, _) = Lib.debounce(1000, callbackSpy)

    debouncedFunc()
    expect(callbackSpy)->notAtTest->toHaveBeenCalled()
    vi->runAllTimers->ignore
    expect(callbackSpy)->toHaveBeenCalled()
  })

  test("debounce works with cancel", () => {
    vi->useFakeTimers->ignore
    let callbackSpy = vi->fn
    let (debouncedFunc, cancel) = Lib.debounce(1000, callbackSpy)

    debouncedFunc()
    cancel()
    vi->runAllTimers->ignore
    expect(callbackSpy)->notAtTest->toHaveBeenCalled()
  })
}

let baiduSuite = () => {
  md5Mock->mockReturnValue("mockSign")->ignore
  francMock->mockReturnValue("cmn")->ignore

  test("Baidu translate endpoint", () => {
    let endpoint = "https://api.fanyi.baidu.com/api/trans/vip/translate"
    expect(endpoint)->toStrictEqual(Baidu.endpoint)
  })

  test("textToSpeech works", () => {
    let url = Baidu.textToSpeech("hello")
    expect(url)->toStrictEqual("https://dict.youdao.com/dictvoice?audio=hello&le=zh")
  })

  test("Baidu translate works", async () => {
    let mockBaiduReturn = {"json": () => {"trans_result": baiduData}}
    fetchSpy->mockResolvedValue(mockBaiduReturn)->ignore
    let ret = await Baidu.translate("你好")
    expect(ret)->toStrictEqual(Ok(BaiduT(baiduData)))
  })

  test("Baidu translate works with no result", async () => {
    let mockBaiduReturn = {"json": () => {"trans_result": None}}
    fetchSpy->mockResolvedValue(mockBaiduReturn)->ignore
    let ret = await Baidu.translate("你好")
    expect(ret)->toStrictEqual(Error("No Translation"))
  })

  test("Baidu translate works with error_msg", async () => {
    let mockBaiduReturn = {"json": () => {"error_msg": "error"}}
    fetchSpy->mockResolvedValue(mockBaiduReturn)->ignore
    let ret = await Baidu.translate("你好")
    expect(ret)->toStrictEqual(Error("error"))
  })

  testEach((
    {"exn": () => Js.Exn.raiseError("js error"), "expected": "js error"},
    {"exn": () => raise(Not_found), "expected": "Unexpected error occurred"},
  ))("Baidu translate works works with $expected exception", async cases => {
    fetchSpy->mockImplementation(() => cases["exn"]())->ignore
    let res = await Lib.fetchByHttp(~url="/dict")
    expect(res)->toStrictEqual(Error(cases["expected"]))
  })

  test("Baidu translate works with no appid", async () => {
    chromeGetStoreSpy->mockReturnValue()->ignore
    let ret = await Baidu.translate("你好")
    expect(ret)->toStrictEqual(Error("No translation key"))
    chromeGetStoreSpy->mockReturnValue({"baiduKey": Js.null})->ignore
    let ret = await Baidu.translate("你好")
    expect(ret)->toStrictEqual(Error("No translation key"))
    // restore default mock
    chromeGetStoreSpy->mockResolvedValue(mockChromeStore)->ignore
  })
}

describe("Utils module", () => {
  describe("Lib module", libSuite)
  describe("Baidu translate module", baiduSuite)

  test("includeWith works", () => {
    let res = includeWith("hello", "he")
    expect(res)->toBe(true)
  })

  test("OfflineDict translate works", async () => {
    let ret = createMockHttpResponse(~data=dictData)
    fetchSpy->mockResolvedValue(ret)->ignore
    let res = await OfflineDict.translate("hello")
    expect(res)->toStrictEqual(Ok(DictT(dictData)))
  })

  testEach([Favorite, History])("recordRemoteAction works %s", async recordType => {
    let ret = createMockHttpResponse(~data=dictData)
    fetchSpy->mockResolvedValue(ret)->ignore
    let res = await recordRemoteAction(~recordType)
    expect(res)->toStrictEqual(Ok(DictT(dictData)))
  })

  test("recordRemoteAction works with error", async () => {
    chromeGetStoreSpy->mockReturnValue({"user": None})->ignore
    let res = await recordRemoteAction(~recordType=Favorite)
    expect(res)->toStrictEqual(Error("nothing"))
    // restore default mock
    chromeGetStoreSpy->mockResolvedValue(mockChromeStore)->ignore
  })
})
