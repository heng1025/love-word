// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";

function useTranslate(text) {
  var match = React.useState(function () {
        return /* Noop */2;
      });
  var setLoading = match[1];
  var match$1 = React.useState(function () {
        return "";
      });
  var seErrText = match$1[1];
  var match$2 = React.useState(function () {
        return {
                TAG: /* Message */2,
                _0: ""
              };
      });
  var setData = match$2[1];
  React.useEffect((function () {
          if (text !== "") {
            setLoading(function (_p) {
                  return /* Yes */0;
                });
            seErrText(function (param) {
                  return "";
                });
            chrome.runtime.sendMessage(text).then(function (ret) {
                  var exit = 0;
                  switch (ret.TAG | 0) {
                    case /* Dict */0 :
                    case /* Baidu */1 :
                        exit = 1;
                        break;
                    case /* Message */2 :
                        var msg = ret._0;
                        seErrText(function (_p) {
                              return msg;
                            });
                        break;
                    
                  }
                  if (exit === 1) {
                    setData(function (_p) {
                          return ret;
                        });
                  }
                  setLoading(function (_p) {
                        return /* No */1;
                      });
                });
          }
          
        }), [text]);
  return {
          loading: match[0],
          errText: match$1[0],
          data: match$2[0]
        };
}

export {
  useTranslate ,
}
/* react Not a pure module */
