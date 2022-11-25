// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Widget from "./Widget.js";

function DictPanel(Props) {
  var data = Props.data;
  var trans = data.translation.split("\n").map(function (v) {
        return React.createElement("p", {
                    key: v,
                    className: "mt-[2px]"
                  }, v);
      });
  var match = data.phonetic !== "";
  var match$1 = data.tag !== "";
  return React.createElement("div", undefined, match ? React.createElement("p", undefined, "[ " + data.phonetic + " ]") : null, React.createElement("div", {
                  className: "mt-1 mb-1"
                }, trans), React.createElement("div", undefined, match$1 ? data.tag.split(" ").map(function (v) {
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
