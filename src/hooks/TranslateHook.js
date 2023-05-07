// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";

function useTranslate(text) {
  var match = React.useState(function () {
        return /* TNone */0;
      });
  var setData = match[1];
  React.useEffect((function () {
          var fetchTranslateResult = async function (txt) {
            if (txt === "") {
              return ;
            }
            setData(function (_p) {
                  return {
                          TAG: /* TLoading */1,
                          _0: true
                        };
                });
            var ret = await chrome.runtime.sendMessage({
                  TAG: /* TranslateMsgContent */0,
                  _0: {
                    text: txt
                  }
                });
            if (ret.TAG === /* Ok */0) {
              var val = ret._0;
              setData(function (_p) {
                    return {
                            TAG: /* TResult */0,
                            _0: val
                          };
                  });
              chrome.runtime.sendMessage({
                    TAG: /* HistoryAddMsgContent */6,
                    _0: {
                      text: txt
                    }
                  });
            } else {
              var msg = ret._0;
              setData(function (_p) {
                    return {
                            TAG: /* TError */2,
                            _0: msg
                          };
                  });
            }
          };
          fetchTranslateResult(text);
        }), [text]);
  return match[0];
}

export {
  useTranslate ,
}
/* react Not a pure module */
