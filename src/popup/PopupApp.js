// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Widget from "../components/Widget.js";
import * as FavButton from "../components/FavButton.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as TranslateHook from "../hooks/TranslateHook.js";
import * as TranslateResult from "../components/TranslateResult.js";

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
  var data = TranslateHook.useTranslate(sourceText);
  var setTextInputRef = function (element) {
    textInput.current = element;
  };
  var focusTextInput = function (param) {
    Belt_Option.forEach(Caml_option.nullable_to_opt(textInput.current), (function (input) {
            input.focus();
          }));
  };
  var handleTranslate = function (param) {
    if (text !== "") {
      return setSourceText(function (param) {
                  return text;
                });
    } else {
      return focusTextInput(undefined);
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
          focusTextInput(undefined);
        }), []);
  var tmp;
  tmp = typeof data === "number" || data.TAG !== /* TResult */0 ? null : React.createElement(FavButton.make, {
          text: sourceText,
          trans: data._0
        });
  return React.createElement("div", {
              className: "card card-compact w-56 bg-base-100 shadow-xl rounded-none"
            }, React.createElement("div", {
                  className: "bg-primary h-5 px-1 text-white flex items-center justify-end"
                }, tmp, React.createElement(Widget.Link.make, {
                      children: React.createElement(Widget.Jump.make, {}),
                      href: "https://fanyi.baidu.com/#en/zh/" + sourceText + "",
                      className: "mx-1 tooltip-bottom"
                    }), React.createElement(Widget.Link.make, {
                      children: React.createElement(Widget.Settting.make, {}),
                      href: "/options.html"
                    })), React.createElement("div", {
                  className: "card-body"
                }, React.createElement("div", {
                      className: "relative"
                    }, React.createElement("textarea", {
                          ref: Caml_option.some(setTextInputRef),
                          className: "textarea textarea-primary w-full leading-4 min-h-16 p-2",
                          placeholder: "please input...",
                          rows: 5,
                          value: text,
                          onKeyDown: handleKeyDown,
                          onChange: handleChange
                        }), React.createElement("button", {
                          className: "btn btn-circle btn-xs btn-primary p-1 absolute bottom-2 right-1",
                          onClick: handleTranslate
                        }, React.createElement(Widget.Search.make, {}))), React.createElement(TranslateResult.TranslateResultWithState.make, {
                      data: data,
                      delay: 200,
                      className: "text-sm"
                    })));
}

var make = PopupApp;

export {
  make ,
}
/* react Not a pure module */
