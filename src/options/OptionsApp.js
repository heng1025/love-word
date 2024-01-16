// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Login from "./Login.js";
import * as Utils from "../Utils.js";
import * as React from "react";
import * as Js_exn from "rescript/lib/es6/js_exn.js";
import * as $$History from "./History.js";
import * as Database from "../Database.js";
import * as Favorite from "./Favorite.js";
import * as Shortcut from "./Shortcut.js";
import * as Core__Array from "@rescript/core/src/Core__Array.js";
import * as TranslateService from "./TranslateService.js";
import * as JsxRuntime from "react/jsx-runtime";
import * as Caml_js_exceptions from "rescript/lib/es6/caml_js_exceptions.js";
import * as RescriptReactRouter from "@rescript/react/src/RescriptReactRouter.js";

async function getRecordsWithServer(recordType) {
  var recordMsg;
  recordMsg = recordType === "history" ? ({
        TAG: "HistoryExtraMsgContent",
        _0: "GetAll"
      }) : ({
        TAG: "FavExtraMsgContent",
        _0: "GetAll"
      });
  var retLocal = await chrome.runtime.sendMessage(recordMsg);
  var val = await Utils.recordRemoteAction(recordType, undefined, undefined);
  var retFromServers;
  retFromServers = val.TAG === "Ok" ? val._0 : [];
  var tranverseLocals = {
    contents: retLocal
  };
  if (tranverseLocals.contents.length === 0) {
    tranverseLocals.contents = retFromServers;
  }
  var db = await Database.getDB();
  var concatLocalWithRemote = function (acc, local) {
    local.sync = false;
    retFromServers.forEach(function (remote) {
          var isTextExisted = local.text === remote.text;
          if (isTextExisted) {
            local.sync = true;
            db.put(recordType, local, undefined);
            return ;
          }
          remote.sync = true;
          var isNotAtLocal = tranverseLocals.contents.every(function (v) {
                return v.text !== remote.text;
              });
          var isNotAtAcc = acc.every(function (v) {
                return v.text !== remote.text;
              });
          if (isNotAtLocal && isNotAtAcc) {
            acc.push(remote);
            return ;
          }
          
        });
    return acc;
  };
  var records = Core__Array.reduce(tranverseLocals.contents, [], concatLocalWithRemote);
  var tx = db.transaction(recordType, "readwrite");
  var pstores = records.map(function (item) {
        return tx.store.add(item);
      });
  pstores.push(tx.done);
  try {
    await Promise.all(pstores);
    return ;
  }
  catch (raw_err){
    var err = Caml_js_exceptions.internalToOCamlException(raw_err);
    if (err.RE_EXN_ID === Js_exn.$$Error) {
      var msg = err._1.message;
      if (msg !== undefined) {
        console.log(msg);
      } else {
        console.log("Err happen");
      }
      return ;
    }
    console.log("Unexpected error occurred");
    return ;
  }
}

function OptionsApp(props) {
  var url = RescriptReactRouter.useUrl(undefined, undefined);
  var match = React.useState(function () {
        return "UnLogined";
      });
  var setUser = match[1];
  var user = match[0];
  React.useEffect((function () {
          var getUser = async function () {
            var result = await chrome.storage.local.get(["user"]);
            var u = result.user;
            return setUser(function (param) {
                        return u;
                      });
          };
          getUser();
        }), []);
  React.useEffect((function () {
          if (url.hash === "") {
            RescriptReactRouter.push("#service");
          }
          
        }), [url]);
  var contentClass = React.useMemo((function () {
          var isRecordUrl = [
              "favorite",
              "history"
            ].includes(url.hash);
          if (isRecordUrl) {
            return "";
          } else {
            return "p-5";
          }
        }), [url.hash]);
  var logout = function (param) {
    chrome.storage.local.remove(["user"]);
    setUser(function (param) {
          return "UnLogined";
        });
  };
  var tmp;
  tmp = typeof user !== "object" ? "" : user.profileImage;
  var hasLoginedComponent = JsxRuntime.jsxs("div", {
        children: [
          JsxRuntime.jsx("label", {
                children: JsxRuntime.jsx("div", {
                      children: JsxRuntime.jsx("img", {
                            src: tmp
                          }),
                      className: "w-10 rounded-full"
                    }),
                className: "btn btn-ghost btn-circle avatar",
                tabIndex: 0
              }),
          JsxRuntime.jsxs("ul", {
                children: [
                  JsxRuntime.jsx("li", {
                        children: JsxRuntime.jsx("a", {
                              children: "Profile",
                              className: "justify-between"
                            })
                      }),
                  JsxRuntime.jsx("li", {
                        children: JsxRuntime.jsx("a", {
                              children: "Logout"
                            }),
                        onClick: logout
                      })
                ],
                className: "mt-3 z-[99] p-2 shadow menu menu-compact dropdown-content bg-base-100 border border-slate-500 rounded-box w-52",
                tabIndex: 1
              })
        ],
        className: "dropdown dropdown-end"
      });
  var loginStatus;
  loginStatus = typeof user !== "object" ? JsxRuntime.jsx("button", {
          children: "Login",
          className: "btn btn-neutral",
          onClick: (function (param) {
              window.login.showModal();
            })
        }) : hasLoginedComponent;
  var handleCommit = async function (user) {
    setUser(user);
    window.login.close();
    await getRecordsWithServer("favorite");
    await getRecordsWithServer("history");
  };
  var match$1 = url.hash === "service";
  var match$2 = url.hash === "shortcut";
  var match$3 = url.hash === "favorite";
  var match$4 = url.hash === "history";
  var match$5 = url.hash;
  var tmp$1;
  switch (match$5) {
    case "favorite" :
        tmp$1 = JsxRuntime.jsx(Favorite.make, {});
        break;
    case "history" :
        tmp$1 = JsxRuntime.jsx($$History.make, {});
        break;
    case "service" :
        tmp$1 = JsxRuntime.jsx(TranslateService.make, {});
        break;
    case "shortcut" :
        tmp$1 = JsxRuntime.jsx(Shortcut.make, {});
        break;
    default:
      tmp$1 = "Page Not Found";
  }
  return JsxRuntime.jsx("div", {
              children: JsxRuntime.jsxs("div", {
                    children: [
                      JsxRuntime.jsxs("div", {
                            children: [
                              JsxRuntime.jsx("div", {
                                    children: JsxRuntime.jsxs("a", {
                                          children: [
                                            JsxRuntime.jsx("img", {
                                                  className: " inline-block mr-2",
                                                  src: "/icons/lw32x32.png"
                                                }),
                                            "Love Word"
                                          ],
                                          className: "btn btn-ghost normal-case text-xl",
                                          href: "#service"
                                        }),
                                    className: "flex-1"
                                  }),
                              JsxRuntime.jsx("div", {
                                    children: loginStatus,
                                    className: "flex gap-2"
                                  }),
                              JsxRuntime.jsx("dialog", {
                                    children: JsxRuntime.jsx("form", {
                                          children: JsxRuntime.jsx(Login.make, {
                                                onSubmit: (function (u) {
                                                    return handleCommit(u);
                                                  }),
                                                onCancel: (function () {
                                                    window.login.close();
                                                  })
                                              }),
                                          className: "modal-box",
                                          method: "dialog"
                                        }),
                                    className: "modal",
                                    id: "login"
                                  })
                            ],
                            className: "navbar bg-base-100"
                          }),
                      JsxRuntime.jsxs("div", {
                            children: [
                              JsxRuntime.jsx("div", {
                                    children: JsxRuntime.jsxs("ul", {
                                          children: [
                                            JsxRuntime.jsx("li", {
                                                  children: JsxRuntime.jsx("span", {
                                                        children: "Setting"
                                                      }),
                                                  className: "menu-title"
                                                }),
                                            JsxRuntime.jsx("li", {
                                                  children: JsxRuntime.jsx("a", {
                                                        children: "Translate Service",
                                                        className: match$1 ? "active" : "",
                                                        href: "#service"
                                                      })
                                                }),
                                            JsxRuntime.jsx("li", {
                                                  children: JsxRuntime.jsx("a", {
                                                        children: "Shortcut",
                                                        className: match$2 ? "active" : "",
                                                        href: "#shortcut"
                                                      })
                                                }),
                                            JsxRuntime.jsx("div", {
                                                  className: "divider"
                                                }),
                                            JsxRuntime.jsx("li", {
                                                  children: JsxRuntime.jsx("span", {
                                                        children: "User"
                                                      }),
                                                  className: "menu-title"
                                                }),
                                            JsxRuntime.jsx("li", {
                                                  children: JsxRuntime.jsx("a", {
                                                        children: "Favorite",
                                                        className: match$3 ? "active" : "",
                                                        href: "#favorite"
                                                      })
                                                }),
                                            JsxRuntime.jsx("li", {
                                                  children: JsxRuntime.jsx("a", {
                                                        children: "History Query",
                                                        className: match$4 ? "active" : "",
                                                        href: "#history"
                                                      })
                                                })
                                          ],
                                          className: "menu bg-base-100 w-56 p-2"
                                        }),
                                    className: "overflow-y-auto bg-base-100"
                                  }),
                              JsxRuntime.jsx("div", {
                                    children: tmp$1,
                                    className: "flex-1 overflow-y-auto bg-base-200 " + contentClass
                                  })
                            ],
                            className: "flex flex-1 gap-1 overflow-y-hidden"
                          })
                    ],
                    className: "flex flex-col gap-1 h-screen"
                  }),
              className: "bg-base-200"
            });
}

var make = OptionsApp;

export {
  getRecordsWithServer ,
  make ,
}
/* Login Not a pure module */
