// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Widget from "./Widget.js";
import * as DictPanel from "./DictPanel.js";
import * as MachineTPanel from "./MachineTPanel.js";

function TranslateResult(props) {
  var className = props.className;
  var errText = props.errText;
  var data = props.data;
  var loading = props.loading;
  var className$1 = className !== undefined ? className : "";
  var errText$1 = errText !== undefined ? errText : "";
  var loading$1 = loading !== undefined ? loading : /* No */1;
  var loadingCN = loading$1 === /* Yes */0 ? "flex min-h-16 justify-center items-center" : "";
  var tmp;
  switch (loading$1) {
    case /* Yes */0 :
        tmp = React.createElement(Widget.Loading.make, {});
        break;
    case /* No */1 :
        if (errText$1 !== "") {
          tmp = React.createElement("div", {
                className: "text-error"
              }, errText$1);
        } else {
          switch (data.TAG | 0) {
            case /* DictT */0 :
                tmp = React.createElement(DictPanel.make, {
                      data: data._0
                    });
                break;
            case /* BaiduT */1 :
                tmp = React.createElement(MachineTPanel.make, {
                      data: data._0
                    });
                break;
            case /* Message */2 :
                tmp = null;
                break;
            
          }
        }
        break;
    case /* Noop */2 :
        tmp = null;
        break;
    
  }
  return React.createElement("div", {
              className: "" + className$1 + " " + loadingCN + " lw-scroll-wrap max-h-52 overflow-y-auto overscroll-contain"
            }, tmp);
}

var make = TranslateResult;

export {
  make ,
}
/* react Not a pure module */
