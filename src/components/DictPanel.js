// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Widget from "./Widget.js";

function DictPanel(Props) {
  var data = Props.data;
  var match = React.useState(function () {
        return null;
      });
  var setAudio = match[1];
  var audio = match[0];
  var match$1 = React.useState(function () {
        return false;
      });
  var setAudioState = match$1[1];
  var trans = data.translation.split("\n").map(function (v) {
        return React.createElement("p", {
                    key: v,
                    className: "mt-[2px]"
                  }, v);
      });
  React.useEffect((function () {
          var src = "https://dict.youdao.com/dictvoice?audio=" + data.word + "&type=1";
          var au = new Audio(src);
          setAudio(function (param) {
                return au;
              });
          if (au !== null) {
            au.onended = (function (param) {
                setAudioState(function (_p) {
                      return false;
                    });
              });
          }
          
        }), []);
  var play = function (param) {
    setAudioState(function (p) {
          return !p;
        });
    if (audio !== null) {
      audio.play();
      return ;
    }
    
  };
  var match$2 = data.phonetic !== "";
  var match$3 = data.tag !== "";
  return React.createElement("div", undefined, match$2 ? React.createElement("div", undefined, React.createElement("span", {
                        className: "mr-2"
                      }, "[ " + data.phonetic + " ]"), React.createElement(Widget.Speaker.make, {
                        isPlay: match$1[0],
                        onClick: play
                      })) : null, React.createElement("div", {
                  className: "my-2"
                }, trans), React.createElement("div", undefined, match$3 ? data.tag.split(" ").map(function (v) {
                        return React.createElement(Widget.Tag.make, {
                                    className: "bg-secondary mr-1 mb-1",
                                    children: v,
                                    key: v
                                  });
                      }) : null));
}

var make = DictPanel;

export {
  make ,
}
/* react Not a pure module */
