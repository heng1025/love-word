// Generated by ReScript, PLEASE EDIT WITH CARE

import Md5 from "md5";
import * as Fixture from "./utils/Fixture.js";
import * as Functions from "../src/Functions.js";
import * as FrancMin from "franc-min";
import * as TranSource from "../src/TranSource.js";

function createFranc(prim0, prim1) {
  return FrancMin.franc(prim0, prim1);
}

function _createMd5(prim) {
  return Md5(prim);
}

vi.mock("md5", undefined);

vi.mock("franc-min", undefined);

var mockChromeStore = {
  user: "iron",
  baiduKey: {
    appid: "testAppid",
    secret: "testSecret"
  }
};

Fixture.chromeGetStoreSpy.mockResolvedValue(mockChromeStore);

describe("TranSource moulde", (function () {
        test("OfflineDict translate works", (async function () {
                var ret = Fixture.createMockHttpResponse(undefined, undefined, Fixture.dictData);
                Fixture.fetchSpy.mockResolvedValue(ret);
                var res = await TranSource.OfflineDict.translate("hello");
                expect(res).toStrictEqual({
                      TAG: "Ok",
                      _0: Fixture.dictData
                    });
              }));
        Md5.mockReturnValue("mockSign");
        FrancMin.franc.mockReturnValue("cmn");
        test("Baidu translate endpoint", (function () {
                expect("https://api.fanyi.baidu.com/api/trans/vip/translate").toStrictEqual(TranSource.Baidu.endpoint);
              }));
        test("textToSpeech works", (function () {
                var url = TranSource.Baidu.textToSpeech("hello");
                expect(url).toStrictEqual("https://dict.youdao.com/dictvoice?audio=hello&le=zh");
              }));
        test("Baidu translate works", (async function () {
                var mockBaiduReturn = {
                  json: (function () {
                      return {
                              trans_result: Fixture.baiduData
                            };
                    })
                };
                Fixture.fetchSpy.mockResolvedValue(mockBaiduReturn);
                var ret = await TranSource.Baidu.translate("你好");
                expect(ret).toStrictEqual({
                      TAG: "Ok",
                      _0: Fixture.baiduData
                    });
              }));
        test("Baidu translate works with no result", (async function () {
                var mockBaiduReturn = {
                  json: (function () {
                      return {
                              trans_result: undefined
                            };
                    })
                };
                Fixture.fetchSpy.mockResolvedValue(mockBaiduReturn);
                var ret = await TranSource.Baidu.translate("你好");
                expect(ret).toStrictEqual({
                      TAG: "Error",
                      _0: "No Translation"
                    });
              }));
        test("Baidu translate works with error_msg", (async function () {
                var mockBaiduReturn = {
                  json: (function () {
                      return {
                              error_msg: "error"
                            };
                    })
                };
                Fixture.fetchSpy.mockResolvedValue(mockBaiduReturn);
                var ret = await TranSource.Baidu.translate("你好");
                expect(ret).toStrictEqual({
                      TAG: "Error",
                      _0: "error"
                    });
              }));
        test.each([
                {
                  exn: (function () {
                      throw new Error("js error");
                    }),
                  expected: "js error"
                },
                {
                  exn: (function () {
                      throw {
                            RE_EXN_ID: "Not_found",
                            Error: new Error()
                          };
                    }),
                  expected: "Unexpected error occurred"
                }
              ])("Baidu translate works works with $expected exception", (async function (cases) {
                Fixture.fetchSpy.mockImplementation(function () {
                      return cases.exn();
                    });
                var res = await Functions.fetchByHttp("/dict", undefined, undefined);
                expect(res).toStrictEqual({
                      TAG: "Error",
                      _0: cases.expected
                    });
              }));
        test("Baidu translate works with no appid", (async function () {
                Fixture.chromeGetStoreSpy.mockReturnValue();
                var ret = await TranSource.Baidu.translate("你好");
                expect(ret).toStrictEqual({
                      TAG: "Error",
                      _0: "No translation key"
                    });
                Fixture.chromeGetStoreSpy.mockReturnValue({
                      baiduKey: null
                    });
                var ret$1 = await TranSource.Baidu.translate("你好");
                expect(ret$1).toStrictEqual({
                      TAG: "Error",
                      _0: "No translation key"
                    });
                Fixture.chromeGetStoreSpy.mockResolvedValue(mockChromeStore);
              }));
      }));

export {
  createFranc ,
  _createMd5 ,
  mockChromeStore ,
}
/*  Not a pure module */
