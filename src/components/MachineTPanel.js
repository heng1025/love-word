// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Widget from "./Widget.js";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as TranSource from "../TranSource.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

function MachineTPanel(props) {
  var data = props.data;
  var audioEl = React.useRef(null);
  var match = React.useState(function () {
        return [];
      });
  var setTransList = match[1];
  var transList = match[0];
  var isEqual = function (text, v) {
    if (v.src === text) {
      return true;
    } else {
      return v.dst === text;
    }
  };
  React.useEffect((function () {
          setTransList(function (param) {
                return data.map(function (v) {
                            var newrecord = Caml_obj.obj_dup(v);
                            newrecord.sourceVisible = false;
                            newrecord.isPlay = false;
                            return newrecord;
                          });
              });
        }), [data]);
  var onEnded = function (param) {
    setTransList(function (p) {
          return p.map(function (v) {
                      var newrecord = Caml_obj.obj_dup(v);
                      newrecord.isPlay = false;
                      return newrecord;
                    });
        });
  };
  var resultEl = transList.map(function (result, idx) {
        var match = result.sourceVisible;
        var text = match !== undefined && match ? result.src : result.dst;
        var match$1 = result.isPlay;
        var isPlay = match$1 !== undefined && match$1 ? true : false;
        return React.createElement("p", {
                    key: idx.toString()
                  }, React.createElement(Widget.Speaker.make, {
                        isPlay: isPlay,
                        onClick: (function (param) {
                            setTransList(function (p) {
                                  return p.map(function (v) {
                                              var s = v.isPlay;
                                              var isPlay = s !== undefined ? isEqual(text, v) && !s : false;
                                              var newrecord = Caml_obj.obj_dup(v);
                                              newrecord.isPlay = isPlay;
                                              return newrecord;
                                            });
                                });
                            Belt_Option.forEach(Caml_option.nullable_to_opt(audioEl.current), (function (audio) {
                                    var current = transList.find(function (v) {
                                          return isEqual(text, v);
                                        });
                                    if (current === undefined) {
                                      return ;
                                    }
                                    var match = current.isPlay;
                                    if (match !== undefined && match) {
                                      audio.src = "";
                                      return ;
                                    }
                                    audio.src = TranSource.Baidu.textToSpeech(text);
                                    audio.play();
                                  }));
                          }),
                        className: "w-5 h-5 mr-1 align-middle"
                      }), React.createElement("span", {
                        className: "align-middle"
                      }, text));
      });
  return React.createElement(React.Fragment, {}, React.createElement("audio", {
                  ref: Caml_option.some(audioEl),
                  className: "w-full h-8 mb-1",
                  onEnded: onEnded
                }), resultEl);
}

var make = MachineTPanel;

export {
  make ,
}
/* react Not a pure module */
