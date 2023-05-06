// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Qs from "qs";
import Md5 from "md5";
import * as Js_exn from "rescript/lib/es6/js_exn.js";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as FrancMin from "franc-min";
import * as Caml_js_exceptions from "rescript/lib/es6/caml_js_exceptions.js";

function getSourceLang(text) {
  return FrancMin.franc(text, {
              minLength: 1,
              only: [
                "eng",
                "cmn"
              ]
            });
}

var apiHost = import.meta.env.LW_API_HOST;

var endpoint = "" + apiHost + "/dict";

async function translate(q) {
  try {
    var res = await fetch("" + endpoint + "?q=" + q + "", undefined);
    var data = await res.json();
    if (data !== undefined) {
      return {
              TAG: /* Ok */0,
              _0: data
            };
    } else {
      return {
              TAG: /* Error */1,
              _0: "Word can not find"
            };
    }
  }
  catch (raw_err){
    var err = Caml_js_exceptions.internalToOCamlException(raw_err);
    if (err.RE_EXN_ID !== Js_exn.$$Error) {
      return {
              TAG: /* Error */1,
              _0: "Unexpected error occurred"
            };
    }
    var msg = err._1.message;
    if (msg !== undefined) {
      return {
              TAG: /* Error */1,
              _0: msg
            };
    } else {
      return {
              TAG: /* Error */1,
              _0: ""
            };
    }
  }
}

var OfflineDict = {
  apiHost: apiHost,
  endpoint: endpoint,
  translate: translate
};

var endpoint$1 = "https://api.fanyi.baidu.com/api/trans/vip/translate";

function textToSpeech(text) {
  var query = Qs.stringify({
        audio: text,
        le: "zh"
      });
  return "https://dict.youdao.com/dictvoice?" + query + "";
}

async function translate$1(q) {
  try {
    var result = await chrome.storage.local.get(["baiduKey"]);
    var baiduKey = result.baiduKey;
    var queryUrl;
    if (baiduKey == null) {
      queryUrl = Js_exn.raiseError("No translation key");
    } else {
      var appid = baiduKey.appid;
      var key = baiduKey.secret;
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
      var val = Js_dict.get(tlDict, sl);
      var query = Qs.stringify({
            q: q,
            from: "auto",
            to: val !== undefined ? val : "zh",
            appid: appid,
            salt: salt,
            sign: sign
          });
      queryUrl = "" + endpoint$1 + "?" + query + "";
    }
    var res = await fetch(queryUrl, undefined);
    var data = await res.json();
    var msg = data.error_msg;
    if (msg !== undefined) {
      return {
              TAG: /* Error */1,
              _0: msg
            };
    }
    var val$1 = data.trans_result;
    if (val$1 !== undefined) {
      return {
              TAG: /* Ok */0,
              _0: val$1
            };
    } else {
      return {
              TAG: /* Error */1,
              _0: "No Translation"
            };
    }
  }
  catch (raw_err){
    var err = Caml_js_exceptions.internalToOCamlException(raw_err);
    if (err.RE_EXN_ID !== Js_exn.$$Error) {
      return {
              TAG: /* Error */1,
              _0: "Unexpected error occurred"
            };
    }
    var msg$1 = err._1.message;
    if (msg$1 !== undefined) {
      return {
              TAG: /* Error */1,
              _0: msg$1
            };
    } else {
      return {
              TAG: /* Error */1,
              _0: ""
            };
    }
  }
}

var Baidu = {
  endpoint: endpoint$1,
  textToSpeech: textToSpeech,
  translate: translate$1
};

async function adapterTrans(text) {
  var sl = getSourceLang(text);
  var wordCount = text.split(" ");
  var baiduResult = async function (param) {
    var res = await translate$1(text);
    if (res.TAG === /* Ok */0) {
      return {
              TAG: /* BaiduT */1,
              baidu: res._0
            };
    } else {
      return {
              TAG: /* TError */2,
              _0: res._0
            };
    }
  };
  if (sl !== "eng" || wordCount.length > 4) {
    return await baiduResult(undefined);
  }
  var val = await translate(text);
  if (val.TAG === /* Ok */0) {
    return {
            TAG: /* DictT */0,
            dict: val._0
          };
  } else {
    return await baiduResult(undefined);
  }
}

export {
  getSourceLang ,
  OfflineDict ,
  Baidu ,
  adapterTrans ,
}
/* apiHost Not a pure module */
