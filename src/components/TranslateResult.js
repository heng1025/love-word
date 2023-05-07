// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Widget from "./Widget.js";
import * as DictPanel from "./DictPanel.js";
import * as MachineTPanel from "./MachineTPanel.js";

function TranslateResult$TranslateResult(props) {
  var className = props.className;
  var data = props.data;
  var className$1 = className !== undefined ? className : "";
  var tmp;
  tmp = data.TAG === /* DictT */0 ? React.createElement(DictPanel.make, {
          data: data.dict
        }) : React.createElement(MachineTPanel.make, {
          data: data.baidu
        });
  return React.createElement("div", {
              className: "" + className$1 + " lw-scroll-wrap max-h-52 overflow-y-auto overscroll-contain"
            }, tmp);
}

var TranslateResult = {
  make: TranslateResult$TranslateResult
};

function TranslateResult$TranslateResultWithState(props) {
  var className = props.className;
  var data = props.data;
  var className$1 = className !== undefined ? className : "";
  var tmp;
  if (typeof data === "number") {
    tmp = null;
  } else {
    switch (data.TAG | 0) {
      case /* TResult */0 :
          tmp = React.createElement(TranslateResult$TranslateResult, {
                data: data._0,
                className: className$1
              });
          break;
      case /* TLoading */1 :
          tmp = data._0 ? React.createElement(Widget.Loading.make, {
                  delay: 450
                }) : null;
          break;
      case /* TError */2 :
          tmp = React.createElement("div", {
                className: "text-error"
              }, data._0);
          break;
      
    }
  }
  return React.createElement("div", {
              className: "" + className$1 + " lw-scroll-wrap max-h-52 overflow-y-auto overscroll-contain"
            }, tmp);
}

var TranslateResultWithState = {
  make: TranslateResult$TranslateResultWithState
};

export {
  TranslateResult ,
  TranslateResultWithState ,
}
/* react Not a pure module */
