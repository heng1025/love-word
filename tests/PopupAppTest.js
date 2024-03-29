// Generated by ReScript, PLEASE EDIT WITH CARE

import * as PopupApp from "../src/popup/PopupApp.js";
import * as TestBinding from "./utils/TestBinding.js";
import * as JsxRuntime from "react/jsx-runtime";
import * as React from "@testing-library/react";

describe("popup page", (function () {
        test("render correctly", (function () {
                TestBinding.ReactTestingLibrary.render(JsxRuntime.jsx(PopupApp.make, {}), undefined, undefined, undefined, undefined, undefined);
                var jumpBtn = React.screen.getByTitle("jump", undefined);
                var settingBtn = React.screen.getByTitle("setting", undefined);
                expect(jumpBtn).toBeInTheDocument();
                expect(settingBtn).toBeInTheDocument();
              }));
      }));

export {
  
}
/*  Not a pure module */
