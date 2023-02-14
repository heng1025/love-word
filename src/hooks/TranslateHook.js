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
          var fetchTranslateResult = async function (txt) {
            if (txt === "") {
              return ;
            }
            setLoading(function (_p) {
                  return /* Yes */0;
                });
            seErrText(function (param) {
                  return "";
                });
            var ret = await chrome.runtime.sendMessage({
                  TAG: /* TranslateMsgContent */0,
                  _0: {
                    text: txt
                  }
                });
            var exit = 0;
            switch (ret.TAG | 0) {
              case /* DictT */0 :
              case /* BaiduT */1 :
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
              chrome.runtime.sendMessage({
                    TAG: /* HistoryAddMsgContent */6,
                    _0: {
                      text: txt
                    }
                  });
            }
            return setLoading(function (_p) {
                        return /* No */1;
                      });
          };
          fetchTranslateResult(text);
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
