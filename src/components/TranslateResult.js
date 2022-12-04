// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Widget from "./Widget.js";
import * as DictPanel from "./DictPanel.js";
import * as MachineTPanel from "./MachineTPanel.js";

function TranslateResult(Props) {
  var loadingOpt = Props.loading;
  var data = Props.data;
  var errTextOpt = Props.errText;
  var classNameOpt = Props.className;
  var loading = loadingOpt !== undefined ? loadingOpt : /* No */1;
  var errText = errTextOpt !== undefined ? errTextOpt : "";
  var className = classNameOpt !== undefined ? classNameOpt : "";
  var tmp;
  switch (loading) {
    case /* Yes */0 :
        tmp = React.createElement(Widget.Loading.make, {});
        break;
    case /* No */1 :
        if (errText !== "") {
          tmp = React.createElement("div", {
                className: "text-error"
              }, errText);
        } else {
          switch (data.TAG | 0) {
            case /* Dict */0 :
                tmp = React.createElement(DictPanel.make, {
                      data: data._0
                    });
                break;
            case /* Baidu */1 :
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
              className: "" + className + " lw-scroll-wrap max-h-52 overflow-y-auto overscroll-contain"
            }, tmp);
}

var make = TranslateResult;

export {
  make ,
}
/* react Not a pure module */
