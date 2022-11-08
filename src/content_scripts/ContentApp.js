// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as TranslateHook from "../hooks/TranslateHook.js";
import * as TranslateResult from "../components/TranslateResult.js";

var common = chrome.runtime.getURL("assets/common.css");

function ContentApp(Props) {
  var containerEl = React.useRef(null);
  var match = React.useState(function () {
        return "0";
      });
  var setTop = match[1];
  var match$1 = React.useState(function () {
        return "0";
      });
  var setLeft = match$1[1];
  var match$2 = React.useState(function () {
        return "0";
      });
  var setOpactity = match$2[1];
  var opacity = match$2[0];
  var match$3 = React.useState(function () {
        return false;
      });
  var setMouseClick = match$3[1];
  var isMouseClick = match$3[0];
  var updatePos = function (ev) {
    var x = ev.pageX - 50 | 0;
    var y = ev.pageY + 30 | 0;
    setTop(function (_p) {
          return "" + y.toString() + "px";
        });
    setLeft(function (_p) {
          return "" + x.toString() + "px";
        });
  };
  var hook = TranslateHook.useTranslate(undefined);
  var showTransPanel = function (target) {
    var text = window.getSelection().toString().trim();
    if (text !== "" && hook.loading === /* Noop */2 && !containerEl.current.contains(target)) {
      hook.handleTranslate(text);
      return setOpactity(function (_p) {
                  return "1";
                });
    }
    
  };
  React.useEffect((function () {
          var firtTime = {
            contents: 0
          };
          var lastTime = {
            contents: 0
          };
          var handleMouseDown = function (e) {
            e.stopPropagation();
            firtTime.contents = Date.now();
          };
          var handleMouseUp = function (ev) {
            ev.stopPropagation();
            lastTime.contents = Date.now();
            var delta = lastTime.contents - firtTime.contents | 0;
            var clickState = delta < 250;
            setMouseClick(function (_p) {
                  return clickState;
                });
            if (!clickState && ev.altKey) {
              updatePos(ev);
              return showTransPanel(ev.target);
            }
            
          };
          var handleDblclick = function (ev) {
            if (ev.altKey) {
              updatePos(ev);
              return showTransPanel(ev.target);
            }
            
          };
          var handleKeyup = function (ev) {
            if (ev.keyCode === 18) {
              return showTransPanel(ev.target);
            }
            
          };
          window.addEventListener("mousedown", handleMouseDown);
          window.addEventListener("dblclick", handleDblclick);
          window.addEventListener("mouseup", handleMouseUp);
          window.addEventListener("keyup", handleKeyup);
          return (function (param) {
                    window.removeEventListener("mousedown", handleMouseDown);
                    window.removeEventListener("dblclick", handleDblclick);
                    window.removeEventListener("mouseup", handleMouseUp);
                    window.removeEventListener("keyup", handleKeyup);
                  });
        }), []);
  React.useEffect((function () {
          var handleClick = function (e) {
            e.stopPropagation();
            if (isMouseClick && opacity === "1" && !containerEl.current.contains(e.target)) {
              setOpactity(function (_p) {
                    return "0";
                  });
              return setMouseClick(function (_p) {
                          return false;
                        });
            }
            
          };
          window.addEventListener("click", handleClick);
          return (function (param) {
                    window.removeEventListener("click", handleClick);
                  });
        }), [
        isMouseClick,
        opacity
      ]);
  var style = {
    left: match$1[0],
    top: match[0],
    opacity: opacity
  };
  return React.createElement("div", {
              ref: containerEl,
              className: "absolute z-[99999]",
              style: style
            }, React.createElement("link", {
                  href: common,
                  rel: "stylesheet"
                }), React.createElement("div", {
                  className: "card w-52 bg-primary text-primary-content"
                }, React.createElement("div", {
                      className: "card-body p-4"
                    }, React.createElement("h4", {
                          className: "card-title text-sm"
                        }, "译文："), React.createElement(TranslateResult.make, {
                          loading: hook.loading,
                          errText: hook.errText,
                          results: hook.results,
                          className: "text-sm min-h-6"
                        }))));
}

var make = ContentApp;

export {
  common ,
  make ,
}
/* common Not a pure module */
