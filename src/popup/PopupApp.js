// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Widget from "../components/Widget.js";
import * as FavButton from "../components/FavButton.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as TranslateHook from "../hooks/TranslateHook.js";
import * as TranslateResult from "../components/TranslateResult.js";
import * as JsxRuntime from "react/jsx-runtime";

function PopupApp(props) {
  var match = React.useState(function () {
        return "";
      });
  var setText = match[1];
  var text = match[0];
  var match$1 = React.useState(function () {
        return "";
      });
  var setSourceText = match$1[1];
  var sourceText = match$1[0];
  var textInput = React.useRef(null);
  var match$2 = TranslateHook.useTranslate(sourceText);
  var data = match$2.data;
  var setTextInputRef = function (element) {
    textInput.current = element;
  };
  var focusTextInput = function () {
    var input = textInput.current;
    if (!(input == null)) {
      input.focus();
      return ;
    }
    
  };
  var handleTranslate = function (param) {
    if (text !== "") {
      return setSourceText(function (param) {
                  return text;
                });
    } else {
      return focusTextInput();
    }
  };
  var handleChange = function ($$event) {
    var value = $$event.target.value;
    setText(function (param) {
          return value;
        });
  };
  var handleKeyDown = function (evt) {
    var isCtrlKey = evt.ctrlKey;
    var key = evt.key;
    if (isCtrlKey && key === "Enter") {
      return setSourceText(function (param) {
                  return text;
                });
    }
    
  };
  React.useEffect((function () {
          focusTextInput();
        }), []);
  var tmp;
  tmp = data !== undefined && data.TAG === "Ok" ? JsxRuntime.jsx(FavButton.make, {
          text: sourceText,
          trans: data._0
        }) : null;
  return JsxRuntime.jsxs("div", {
              children: [
                JsxRuntime.jsxs("div", {
                      children: [
                        tmp,
                        JsxRuntime.jsx(Widget.Link.make, {
                              children: JsxRuntime.jsx(Widget.Jump.make, {}),
                              href: "https://fanyi.baidu.com/#en/zh/" + sourceText,
                              className: "mx-1 tooltip-bottom"
                            }),
                        JsxRuntime.jsx(Widget.Link.make, {
                              children: JsxRuntime.jsx(Widget.Settting.make, {}),
                              href: "/options.html"
                            })
                      ],
                      className: "bg-primary h-5 px-1 text-white flex items-center justify-end"
                    }),
                JsxRuntime.jsxs("div", {
                      children: [
                        JsxRuntime.jsxs("div", {
                              children: [
                                JsxRuntime.jsx("textarea", {
                                      ref: Caml_option.some(setTextInputRef),
                                      className: "textarea textarea-primary w-full leading-4 min-h-16 p-2",
                                      placeholder: "please input...",
                                      rows: 5,
                                      value: text,
                                      onKeyDown: handleKeyDown,
                                      onChange: handleChange
                                    }),
                                JsxRuntime.jsx("button", {
                                      children: JsxRuntime.jsx(Widget.Search.make, {}),
                                      className: "btn btn-circle btn-xs btn-primary p-1 absolute bottom-2 right-1",
                                      onClick: handleTranslate
                                    })
                              ],
                              className: "relative"
                            }),
                        JsxRuntime.jsx(TranslateResult.make, {
                              loading: match$2.loading,
                              data: data,
                              delay: 200,
                              className: "text-sm"
                            })
                      ],
                      className: "card-body"
                    })
              ],
              className: "card card-compact w-56 bg-base-100 shadow-xl rounded-none"
            });
}

var make = PopupApp;

export {
  make ,
}
/* react Not a pure module */
