// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Widget from "../components/Widget.js";
import * as Functions from "../Functions.js";
import * as JsxRuntime from "react/jsx-runtime";
import * as RescriptReactRouter from "@rescript/react/src/RescriptReactRouter.js";

function Login(props) {
  var onCancel = props.onCancel;
  var onSubmit = props.onSubmit;
  var url = RescriptReactRouter.useUrl(undefined, undefined);
  var match = React.useState(function () {
        return "";
      });
  var setUsername = match[1];
  var username = match[0];
  var match$1 = React.useState(function () {
        return "";
      });
  var setPassword = match$1[1];
  var password = match$1[0];
  var match$2 = React.useState(function () {
        return true;
      });
  var setPasswordVisible = match$2[1];
  var passwordVisible = match$2[0];
  var handleSubmit = async function () {
    var val = await Functions.fetchByHttp("/login", "post", {
          username: username,
          password: password
        });
    if (val.TAG !== "Ok") {
      return ;
    }
    var val$1 = val._0;
    chrome.storage.local.set({
          user: val$1
        });
    await onSubmit(val$1);
    if ([
          "favorite",
          "history"
        ].includes(url.hash)) {
      window.location.reload();
      return ;
    }
    
  };
  return JsxRuntime.jsxs("div", {
              children: [
                JsxRuntime.jsx("h3", {
                      children: "Login"
                    }),
                JsxRuntime.jsxs("div", {
                      children: [
                        JsxRuntime.jsx("label", {
                              children: JsxRuntime.jsx("span", {
                                    children: "Username",
                                    className: "label-text"
                                  }),
                              className: "label"
                            }),
                        JsxRuntime.jsx("input", {
                              className: "input input-bordered w-full",
                              placeholder: "Username",
                              type: "text",
                              value: username,
                              onChange: (function (e) {
                                  setUsername(function (param) {
                                        return e.target.value;
                                      });
                                })
                            })
                      ],
                      className: "form-control "
                    }),
                JsxRuntime.jsxs("div", {
                      children: [
                        JsxRuntime.jsx("label", {
                              children: JsxRuntime.jsx("span", {
                                    children: "Password",
                                    className: "label-text"
                                  }),
                              className: "label"
                            }),
                        JsxRuntime.jsxs("div", {
                              children: [
                                JsxRuntime.jsx("input", {
                                      className: "input input-bordered w-full pr-8",
                                      placeholder: "Password",
                                      type: passwordVisible ? "password" : "text",
                                      value: password,
                                      onChange: (function (e) {
                                          setPassword(function (param) {
                                                return e.target.value;
                                              });
                                        })
                                    }),
                                JsxRuntime.jsx("span", {
                                      children: passwordVisible ? JsxRuntime.jsx(Widget.EyeSlash.make, {}) : JsxRuntime.jsx(Widget.Eye.make, {}),
                                      className: "cursor-pointer absolute w-6 h-6 top-1/2 right-1.5 -translate-y-1/2",
                                      onClick: (function (param) {
                                          setPasswordVisible(function (_p) {
                                                return !passwordVisible;
                                              });
                                        })
                                    })
                              ],
                              className: "relative"
                            })
                      ],
                      className: "form-control mt-5"
                    }),
                JsxRuntime.jsxs("div", {
                      children: [
                        JsxRuntime.jsx("button", {
                              children: "Submit",
                              className: "btn btn-neutral",
                              onClick: (function (param) {
                                  handleSubmit();
                                })
                            }),
                        JsxRuntime.jsx("label", {
                              children: "close",
                              className: "btn",
                              onClick: (function (param) {
                                  onCancel();
                                })
                            })
                      ],
                      className: "modal-action fle mt-8 justify-center"
                    })
              ]
            });
}

var make = Login;

export {
  make ,
}
/* react Not a pure module */
