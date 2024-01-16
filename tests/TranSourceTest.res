open TestBinding.Vitest
open Fixture
open Functions
open TranSource
open Utils

// just use for import some module in js file
let {createFranc} = module(Common.FrancMin)
let _createMd5 = Common.Md5.createMd5

// Type Cast (mock)
@val external francMock: mockInstance = "FrancMin.franc"
@val external md5Mock: mockInstance = "Md5"

vi->mock("md5")
vi->mock("franc-min")

let mockChromeStore = {
  "user": "iron",
  "baiduKey": {
    "appid": "testAppid",
    "secret": "testSecret",
  },
}

chromeGetStoreSpy->mockResolvedValue(mockChromeStore)->ignore

describe("TranSource moulde", () => {
  test("OfflineDict translate works", async () => {
    let ret = createMockHttpResponse(~data=dictData)
    fetchSpy->mockResolvedValue(ret)->ignore
    let res = await OfflineDict.translate("hello")
    expect(res)->toStrictEqual(Ok(DictT(dictData)))
  })

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
    {"exn": () => Error.raise(Error.make("js error")), "expected": "js error"},
    {"exn": () => raise(Not_found), "expected": "Unexpected error occurred"},
  ))("Baidu translate works works with $expected exception", async cases => {
    fetchSpy->mockImplementation(() => cases["exn"]())->ignore
    let res = await fetchByHttp(~url="/dict")
    expect(res)->toStrictEqual(Error(cases["expected"]))
  })

  test("Baidu translate works with no appid", async () => {
    chromeGetStoreSpy->mockReturnValue()->ignore
    let ret = await Baidu.translate("你好")
    expect(ret)->toStrictEqual(Error("No translation key"))
    chromeGetStoreSpy->mockReturnValue({"baiduKey": Null.null})->ignore
    let ret = await Baidu.translate("你好")
    expect(ret)->toStrictEqual(Error("No translation key"))
    // restore default mock
    chromeGetStoreSpy->mockResolvedValue(mockChromeStore)->ignore
  })
})
