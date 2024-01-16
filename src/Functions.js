// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Js_exn from "rescript/lib/es6/js_exn.js";
import * as FrancMin from "franc-min";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Caml_js_exceptions from "rescript/lib/es6/caml_js_exceptions.js";

var apiHost = import.meta.env.LW_API_HOST;

function getSourceLang(text) {
  return FrancMin.franc(text, {
              minLength: 1,
              only: [
                "eng",
                "cmn"
              ]
            });
}

function includeWith(target, substring) {
  return new RegExp(substring).test(target);
}

async function fetchByHttp(url, methodOpt, body) {
  var method = methodOpt !== undefined ? methodOpt : "get";
  try {
    var headers = {};
    var result = await chrome.storage.local.get(["user"]);
    var user = result.user;
    if (!(user == null)) {
      Object.assign(headers, {
            "x-token": user.token
          });
    }
    var res = body !== undefined ? await fetch(apiHost + url, {
            method: method,
            headers: Caml_option.some(headers),
            body: Caml_option.some(JSON.stringify(Caml_option.valFromOption(body)))
          }) : await fetch(apiHost + url, {
            headers: Caml_option.some(headers)
          });
    var json = await res.json();
    var match = json.code;
    if (match !== 0) {
      return {
              TAG: "Error",
              _0: json.msg
            };
    } else {
      return {
              TAG: "Ok",
              _0: json.data
            };
    }
  }
  catch (raw_err){
    var err = Caml_js_exceptions.internalToOCamlException(raw_err);
    if (err.RE_EXN_ID !== Js_exn.$$Error) {
      return {
              TAG: "Error",
              _0: "Unexpected error occurred"
            };
    }
    var msg = err._1.message;
    if (msg !== undefined) {
      return {
              TAG: "Error",
              _0: msg
            };
    } else {
      return {
              TAG: "Error",
              _0: "Err happen"
            };
    }
  }
}

function debounce(delay, callback) {
  var timeoutID = {
    contents: null
  };
  var cancelled = {
    contents: false
  };
  var clearExistingTimeout = function () {
    var timer = timeoutID.contents;
    if (timer !== null) {
      clearTimeout(timer);
      return ;
    }
    
  };
  var cancel = function () {
    clearExistingTimeout();
    cancelled.contents = true;
  };
  var wrapper = function () {
    clearExistingTimeout();
    var match = cancelled.contents;
    if (match) {
      return ;
    } else {
      timeoutID.contents = setTimeout((function () {
              callback();
            }), delay);
      return ;
    }
  };
  return [
          wrapper,
          cancel
        ];
}

export {
  apiHost ,
  getSourceLang ,
  includeWith ,
  fetchByHttp ,
  debounce ,
}
/* apiHost Not a pure module */
