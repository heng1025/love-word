// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Qs from "qs";
import Md5 from "md5";
import * as Js_exn from "rescript/lib/es6/js_exn.js";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as FrancMin from "franc-min";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
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
    if (!(timeoutID.contents == null)) {
      return Js_null_undefined.iter(timeoutID.contents, (function (timer) {
                    clearTimeout(timer);
                  }));
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

var Lib = {
  fetchByHttp: fetchByHttp,
  debounce: debounce
};

async function translate(q) {
  return await fetchByHttp("/dict?q=" + q, undefined, undefined);
}

var OfflineDict = {
  translate: translate
};

var endpoint = "https://api.fanyi.baidu.com/api/trans/vip/translate";

function textToSpeech(text) {
  var query = Qs.stringify({
        audio: text,
        le: "zh"
      });
  return "https://dict.youdao.com/dictvoice?" + query;
}

async function translate$1(q) {
  try {
    var val = await chrome.storage.local.get(["baiduKey"]);
    var result = val !== undefined ? Caml_option.valFromOption(val).baiduKey : Js_exn.raiseError("No translation key");
    var queryUrl;
    if (result == null) {
      queryUrl = Js_exn.raiseError("No translation key");
    } else {
      var appid = result.appid;
      var key = result.secret;
      var salt = Date.now().toString();
      var sign = Md5(appid + q + salt + key);
      var sl = getSourceLang(q);
      var tlDict = Js_dict.fromList({
            hd: [
              "cmn",
              "en"
            ],
            tl: /* [] */0
          });
      var val$1 = Js_dict.get(tlDict, sl);
      var query = Qs.stringify({
            q: q,
            from: "auto",
            to: val$1 !== undefined ? val$1 : "zh",
            appid: appid,
            salt: salt,
            sign: sign
          });
      queryUrl = endpoint + "?" + query;
    }
    var res = await fetch(queryUrl, undefined);
    var data = await res.json();
    var msg = data.error_msg;
    if (msg !== undefined) {
      return {
              TAG: "Error",
              _0: msg
            };
    }
    var val$2 = data.trans_result;
    if (val$2 !== undefined) {
      return {
              TAG: "Ok",
              _0: val$2
            };
    } else {
      return {
              TAG: "Error",
              _0: "No Translation"
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
    var msg$1 = err._1.message;
    if (msg$1 !== undefined) {
      return {
              TAG: "Error",
              _0: msg$1
            };
    } else {
      return {
              TAG: "Error",
              _0: "error"
            };
    }
  }
}

var Baidu = {
  endpoint: endpoint,
  textToSpeech: textToSpeech,
  translate: translate$1
};

async function recordRemoteAction(recordType, data, methodOpt) {
  var method = methodOpt !== undefined ? methodOpt : "post";
  var loginInfo = await chrome.storage.local.get(["user"]);
  var match = loginInfo.user;
  if (match == null) {
    return {
            TAG: "Error",
            _0: "nothing"
          };
  }
  var rType;
  rType = recordType === "history" ? "1" : "2";
  var url = "/records?type=" + rType;
  if (data !== undefined) {
    return await fetchByHttp(url, method, Caml_option.some(Caml_option.valFromOption(data)));
  } else {
    return await fetchByHttp(url, undefined, undefined);
  }
}

export {
  apiHost ,
  getSourceLang ,
  includeWith ,
  Lib ,
  OfflineDict ,
  Baidu ,
  recordRemoteAction ,
}
/* apiHost Not a pure module */
