// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as RecordHook from "../hooks/RecordHook.js";
import * as RecordAction from "./RecordAction.js";
import * as TranslateResult from "../components/TranslateResult.js";

function Favorite(props) {
  var match = RecordHook.useRecord("favorite");
  var onCheck = match.onCheck;
  var records = match.records;
  var recordEles = records.map(function (record) {
        var date = record.date;
        var checked = record.checked;
        var sync = record.sync;
        var boarderClass = checked ? "border-primary" : "";
        var val = record.translation;
        return React.createElement("div", {
                    key: date.toString(),
                    className: "card card-compact w-72 card-bordered cursor-pointer bg-base-100 shadow-xl " + boarderClass,
                    onClick: (function (param) {
                        onCheck(record);
                      })
                  }, React.createElement("div", {
                        className: "card-body"
                      }, React.createElement("div", {
                            className: "border-b pb-1"
                          }, React.createElement("div", {
                                className: "flex justify-between"
                              }, React.createElement("div", undefined, React.createElement("span", undefined, new Date(date).toLocaleDateString()), React.createElement("span", {
                                        className: "ml-2"
                                      }, sync ? "sync" : "")), React.createElement("a", {
                                    title: record.title,
                                    href: record.url,
                                    target: "_blank"
                                  }, React.createElement("img", {
                                        className: "w-5",
                                        src: record.favIconUrl
                                      }))), React.createElement("p", {
                                className: "font-bold text-xl line-clamp-1"
                              }, record.text)), val !== undefined ? React.createElement(TranslateResult.TranslateResult.make, {
                              data: val
                            }) : null));
      });
  return React.createElement(React.Fragment, {}, React.createElement(RecordAction.make, {
                  records: records.filter(function (v) {
                        return v.checked;
                      }),
                  onDelete: match.onDelete,
                  onClear: match.onClear,
                  onSearch: match.onSearch,
                  onCancel: match.onCancel
                }), React.createElement("div", {
                  className: "flex flex-wrap gap-4 p-5"
                }, recordEles));
}

var make = Favorite;

export {
  make ,
}
/* react Not a pure module */
