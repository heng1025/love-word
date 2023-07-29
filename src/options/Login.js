// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Utils from "../Utils.js";
import * as React from "react";
import * as Widget from "../components/Widget.js";

function Login(props) {
  var onCancel = props.onCancel;
  var onSubmit = props.onSubmit;
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
    var val = await Utils.Lib.fetchByHttp("/login", "post", {
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
    return onSubmit(val$1);
  };
  return React.createElement("div", undefined, React.createElement("h3", undefined, "Login"), React.createElement("div", {
                  className: "form-control "
                }, React.createElement("label", {
                      className: "label"
                    }, React.createElement("span", {
                          className: "label-text"
                        }, "Username")), React.createElement("input", {
                      className: "input input-bordered input-primary w-full",
                      placeholder: "Username",
                      type: "text",
                      value: username,
                      onChange: (function (e) {
                          setUsername(function (param) {
                                return e.target.value;
                              });
                        })
                    })), React.createElement("div", {
                  className: "form-control mt-5"
                }, React.createElement("label", {
                      className: "label"
                    }, React.createElement("span", {
                          className: "label-text"
                        }, "Password")), React.createElement("div", {
                      className: "relative"
                    }, React.createElement("input", {
                          className: "input input-bordered input-primary w-full pr-8",
                          placeholder: "Password",
                          type: passwordVisible ? "password" : "text",
                          value: password,
                          onChange: (function (e) {
                              setPassword(function (param) {
                                    return e.target.value;
                                  });
                            })
                        }), React.createElement("span", {
                          className: "cursor-pointer absolute w-6 h-6 top-1/2 right-1.5 -translate-y-1/2",
                          onClick: (function (param) {
                              setPasswordVisible(function (_p) {
                                    return !passwordVisible;
                                  });
                            })
                        }, passwordVisible ? React.createElement(Widget.EyeSlash.make, {}) : React.createElement(Widget.Eye.make, {})))), React.createElement("div", {
                  className: "modal-action fle mt-8 justify-center"
                }, React.createElement("button", {
                      className: "btn btn-primary",
                      onClick: (function (param) {
                          handleSubmit(undefined);
                        })
                    }, "Submit"), React.createElement("label", {
                      className: "btn",
                      onClick: (function (param) {
                          onCancel(undefined);
                        })
                    }, "close")));
}

var make = Login;

export {
  make ,
}
/* Utils Not a pure module */
