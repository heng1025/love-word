// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Fixture from "../utils/Fixture.js";
import * as TranSource from "../../src/TranSource.js";
import * as TestBinding from "../utils/TestBinding.js";
import * as TranslateService from "../../src/options/TranslateService.js";
import * as JsxRuntime from "react/jsx-runtime";
import * as React from "@testing-library/react";
import * as UserEvent from "@testing-library/user-event";

async function factory(importOriginal) {
  var mod = await importOriginal();
  var copy = Object.assign({}, mod);
  copy.Baidu.translate = vi.fn(undefined);
  return copy;
}

vi.mock("../../src/TranSource.js", factory);

var openIdConfig = {
  appid: "testAppid",
  secret: "testSecret"
};

describe("TranslateService in options page", (function () {
        beforeAll(function () {
              return Fixture.chromeGetStoreSpy.mockResolvedValue({
                          baiduKey: openIdConfig
                        });
            });
        test("render correctly", (async function () {
                TestBinding.ReactTestingLibrary.render(JsxRuntime.jsx(TranslateService.make, {}), undefined, undefined, undefined, undefined, undefined);
                var appidLabel = await React.screen.findByText("baidu appid", undefined);
                var secretLabel = await React.screen.findByText("baidu secret", undefined);
                expect(appidLabel).toBeInTheDocument();
                expect(secretLabel).toBeInTheDocument();
              }));
        test("appid input value change", (async function () {
                TestBinding.ReactTestingLibrary.render(JsxRuntime.jsx(TranslateService.make, {}), undefined, undefined, undefined, undefined, undefined);
                var appidInput = await React.screen.findByPlaceholderText("Appid", undefined);
                expect(appidInput).toHaveValue(openIdConfig.appid);
                var user = UserEvent.userEvent.setup(undefined);
                await user.clear(appidInput);
                await user.type(appidInput, "abcd");
                expect(appidInput).toHaveValue("abcd");
              }));
        test("secret input value change", (async function () {
                TestBinding.ReactTestingLibrary.render(JsxRuntime.jsx(TranslateService.make, {}), undefined, undefined, undefined, undefined, undefined);
                var secretInput = await React.screen.findByPlaceholderText("Secret", undefined);
                expect(secretInput).toHaveValue(openIdConfig.secret);
                var user = UserEvent.userEvent.setup(undefined);
                await user.clear(secretInput);
                await user.type(secretInput, "1234");
                expect(secretInput).toHaveValue("1234");
              }));
        test("secret input value can be seen", (async function () {
                TestBinding.ReactTestingLibrary.render(JsxRuntime.jsx(TranslateService.make, {}), undefined, undefined, undefined, undefined, undefined);
                var eyeSplashIcon = React.screen.getByTitle("eyeSlash", undefined);
                var user = UserEvent.userEvent.setup(undefined);
                await user.click(eyeSplashIcon);
                var eyeIcon = React.screen.getByTitle("eye", undefined);
                expect(eyeIcon).toBeInTheDocument();
                expect(eyeSplashIcon).not.toBeInTheDocument();
              }));
        test("save appid/secret success", (async function () {
                Fixture.chromeSetStoreSpy.mockResolvedValue();
                TranSource.Baidu.translate.mockResolvedValue({
                      TAG: "Ok",
                      _0: "success"
                    });
                TestBinding.ReactTestingLibrary.render(JsxRuntime.jsx(TranslateService.make, {}), undefined, undefined, undefined, undefined, undefined);
                var submitBtn = React.screen.getByRole("button", {
                      name: "Submit"
                    });
                var user = UserEvent.userEvent.setup(undefined);
                await user.click(submitBtn);
                expect(submitBtn).toHaveClass("btn-disabled");
              }));
        test("save appid/secret fail with alert message", (async function () {
                Fixture.chromeSetStoreSpy.mockResolvedValue();
                TranSource.Baidu.translate.mockResolvedValue({
                      TAG: "Error",
                      _0: "ops"
                    });
                TestBinding.ReactTestingLibrary.render(JsxRuntime.jsx(TranslateService.make, {}), undefined, undefined, undefined, undefined, undefined);
                var submitBtn = React.screen.getByRole("button", {
                      name: "Submit"
                    });
                var user = UserEvent.userEvent.setup(undefined);
                await user.click(submitBtn);
                var alertIcon = await React.screen.findByTitle("alert", undefined);
                expect(alertIcon).toBeInTheDocument();
              }));
      }));

export {
  factory ,
  openIdConfig ,
}
/*  Not a pure module */
