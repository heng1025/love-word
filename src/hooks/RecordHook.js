// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";

function includeWith(target, substring) {
  return new RegExp(substring).test(target);
}

function useRecord(recordType) {
  var match = React.useState(function () {
        return [];
      });
  var setRecords = match[1];
  var records = match[0];
  var getAll = function (param) {
    chrome.runtime.sendMessage({
            _type: /* Message */{
              _0: recordType,
              _1: /* GETALL */2
            }
          }).then(function (ret) {
          var rs = ret.sort(function (v1, v2) {
                  return v2.date - v1.date | 0;
                }).map(function (v) {
                v.checked = false;
                return v;
              });
          setRecords(function (param) {
                return rs;
              });
        });
  };
  React.useEffect((function () {
          getAll(undefined);
        }), [recordType]);
  var onSearch = function (val) {
    if (val === "") {
      return getAll(undefined);
    }
    var rs = records.filter(function (item) {
          var target = item.text;
          return new RegExp(val).test(target);
        });
    setRecords(function (param) {
          return rs;
        });
  };
  var onCheck = function (record) {
    var rs = records.map(function (v) {
          var date = record.date;
          var checked = record.checked;
          if (date === v.date) {
            v.checked = !checked;
          }
          return v;
        });
    setRecords(function (param) {
          return rs;
        });
  };
  var onCancel = function () {
    var rs = records.map(function (v) {
          v.checked = false;
          return v;
        });
    return setRecords(function (param) {
                return rs;
              });
  };
  var onDelete = function (checkedRecords) {
    chrome.runtime.sendMessage({
            _type: /* Message */{
              _0: recordType,
              _1: /* DELETE */3
            },
            date: checkedRecords.map(function (v) {
                  return v.date;
                })
          }).then(function (param) {
          getAll(undefined);
        });
  };
  var onClear = function () {
    chrome.runtime.sendMessage({
            _type: /* Message */{
              _0: recordType,
              _1: /* CLEAR */4
            }
          }).then(function (param) {
          getAll(undefined);
        });
  };
  return {
          records: records,
          onCheck: onCheck,
          onSearch: onSearch,
          onDelete: onDelete,
          onClear: onClear,
          onCancel: onCancel
        };
}

export {
  includeWith ,
  useRecord ,
}
/* react Not a pure module */
