// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as RecordHook from "../hooks/RecordHook.js";
import * as RecordAction from "./RecordAction.js";
import * as TranslateResult from "../components/TranslateResult.js";

function Favorite(Props) {
  var match = RecordHook.useRecord(/* FAVORITE */1);
  var onCheck = match.onCheck;
  var records = match.records;
  var recordEles = records.map(function (v) {
        var date = v.date;
        var boarderClass = v.checked ? "border-primary" : "";
        var val = v.trans;
        return React.createElement("div", {
                    key: date.toString(),
                    className: "card card-compact w-72 card-bordered cursor-pointer bg-base-100 shadow-xl " + boarderClass + "",
                    onClick: (function (param) {
                        onCheck(v);
                      })
                  }, React.createElement("div", {
                        className: "card-body"
                      }, React.createElement("div", {
                            className: "border-b pb-1"
                          }, React.createElement("div", {
                                className: "flex justify-between"
                              }, React.createElement("span", undefined, new Date(date).toLocaleDateString()), React.createElement("a", {
                                    title: v.title,
                                    href: v.url,
                                    target: "_blank"
                                  }, React.createElement("img", {
                                        className: "w-5",
                                        src: v.favIconUrl
                                      }))), React.createElement("p", {
                                className: "font-bold text-xl line-clamp-1"
                              }, v.text)), val !== undefined ? React.createElement(TranslateResult.make, {
                              data: val
                            }) : null));
      });
  return React.createElement(React.Fragment, undefined, React.createElement(RecordAction.make, {
                  className: "mb-4",
                  records: records.filter(function (v) {
                        return v.checked;
                      }),
                  onDelete: match.onDelete,
                  onClear: match.onClear,
                  onSearch: match.onSearch,
                  onCancel: match.onCancel
                }), React.createElement("div", {
                  className: "flex flex-wrap gap-4"
                }, recordEles));
}

var make = Favorite;

export {
  make ,
}
/* react Not a pure module */
