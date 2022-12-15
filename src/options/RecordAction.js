// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";

function RecordAction(Props) {
  var clOpt = Props.className;
  var recordsOpt = Props.records;
  var onDelete = Props.onDelete;
  var onClear = Props.onClear;
  var onSearch = Props.onSearch;
  var onCancel = Props.onCancel;
  var cl = clOpt !== undefined ? clOpt : "";
  var records = recordsOpt !== undefined ? recordsOpt : [];
  var match = React.useState(function () {
        return /* None */2;
      });
  var setBtnState = match[1];
  var btnState = match[0];
  var checkedLen = records.length;
  var onClick = function (param) {
    switch (btnState) {
      case /* DELETE */0 :
          return onDelete(records);
      case /* CLEAR */1 :
          return onClear();
      case /* None */2 :
          return ;
      
    }
  };
  return React.createElement("div", {
              className: "sticky top-0 z-50 bg-base-100 p-4 border-b-2"
            }, React.createElement("input", {
                  className: "modal-toggle",
                  id: "my-modal",
                  type: "checkbox"
                }), React.createElement("div", {
                  className: "modal"
                }, React.createElement("div", {
                      className: "modal-box"
                    }, React.createElement("h3", {
                          className: "font-bold text-lg"
                        }, "Do you confirm?"), React.createElement("div", {
                          className: "modal-action"
                        }, React.createElement("div", {
                              className: "btn-group"
                            }, React.createElement("label", {
                                  className: "btn btn-error",
                                  htmlFor: "my-modal",
                                  onClick: onClick
                                }, "Confirm"), React.createElement("label", {
                                  className: "btn",
                                  htmlFor: "my-modal"
                                }, "Cancel"))))), React.createElement("div", {
                  className: "" + cl + " flex gap-5 items-center"
                }, React.createElement("input", {
                      className: "input input-primary w-full max-w-xs",
                      placeholder: "Search...",
                      type: "text",
                      onChange: (function (e) {
                          onSearch(e.target.value);
                        })
                    }), checkedLen > 0 ? React.createElement("div", {
                        className: "btn-group"
                      }, React.createElement("label", {
                            className: "btn btn-warning gap-2",
                            htmlFor: "my-modal",
                            onClick: (function (param) {
                                setBtnState(function (param) {
                                      return /* DELETE */0;
                                    });
                              })
                          }, React.createElement("span", undefined, "Delete"), React.createElement("span", undefined, "(" + checkedLen.toString() + ")")), React.createElement("label", {
                            className: "btn btn-error",
                            htmlFor: "my-modal",
                            onClick: (function (param) {
                                setBtnState(function (param) {
                                      return /* CLEAR */1;
                                    });
                              })
                          }, "Clear"), React.createElement("button", {
                            className: "btn",
                            onClick: (function (param) {
                                onCancel();
                              })
                          }, "Cancel")) : null));
}

var make = RecordAction;

export {
  make ,
}
/* react Not a pure module */
