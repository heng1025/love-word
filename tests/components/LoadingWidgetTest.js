// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Widget from "../../src/components/Widget.js";
import * as TestBinding from "../utils/TestBinding.js";
import * as JsxRuntime from "react/jsx-runtime";
import * as React from "@testing-library/react";

describe("Loading widget", (function () {
        test("Loading commponent", (async function () {
                TestBinding.ReactTestingLibrary.render(JsxRuntime.jsx(Widget.Loading.make, {
                          delay: 150
                        }), undefined, undefined, undefined, undefined, undefined);
                var loading = await React.screen.findByTestId("loading", undefined);
                expect(loading).toBeInTheDocument();
              }));
      }));

export {
  
}
/*  Not a pure module */
