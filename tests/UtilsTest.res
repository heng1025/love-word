open TestBinding.Vitest
open Fixture
open Utils

let mockChromeStore = {
  "user": "iron",
  "baiduKey": {
    "appid": "testAppid",
    "secret": "testSecret",
  },
}

chromeGetStoreSpy->mockResolvedValue(mockChromeStore)->ignore

describe("Utils module", () => {
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
