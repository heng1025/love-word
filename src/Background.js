// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Utils from "./Utils.js";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as Database from "./Database.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

function getBrowserTab(sender) {
  var v = sender.tab;
  if (v !== undefined) {
    return Caml_option.valFromOption(v);
  } else {
    return {
            url: sender.url,
            title: "Love Word",
            favIconUrl: sender.origin + "/icons/lw32x32.png"
          };
  }
}

var dbInstance = Database.getDB(undefined);

async function translateMessageHandler(msg, sendResponse) {
  var ret = await Utils.adapterTrans(msg.text);
  return sendResponse(ret);
}

async function favGetOneMessageHandler(msg, sendResponse) {
  var db = await dbInstance;
  var ret = await db.getFromIndex("favorite", "text", msg.text);
  return sendResponse(ret);
}

async function favAddMessageHandler(msg, sender, sendResponse) {
  var db = await dbInstance;
  var tab = getBrowserTab(sender);
  var data_url = tab.url;
  var data_title = tab.title;
  var data_favIconUrl = tab.favIconUrl;
  var data_date = Date.now();
  var data_text = msg.text;
  var data_translation = Caml_option.some(msg.translation);
  var data = {
    url: data_url,
    title: data_title,
    favIconUrl: data_favIconUrl,
    date: data_date,
    text: data_text,
    translation: data_translation
  };
  await db.add("favorite", data, undefined);
  await Utils.recordRemoteAction("favorite", data, "post");
  return sendResponse(true);
}

async function favDeleteOneMessageHandler(msg, sendResponse) {
  var db = await dbInstance;
  var key = await db.getKeyFromIndex("favorite", "text", msg.text);
  await db.delete("favorite", key);
  await Utils.recordRemoteAction("favorite", {
        text: [msg.text]
      }, "delete");
  return sendResponse(false);
}

async function recordAddManyMessageHandler(recordType, msg, sendResponse) {
  var didNotSyncedRecords = msg.filter(function (v) {
        return !v.sync;
      });
  if (didNotSyncedRecords.length !== 0) {
    await Utils.recordRemoteAction(recordType, didNotSyncedRecords, "post");
    var db = await dbInstance;
    var tx = db.transaction(recordType, "readwrite");
    var pstores = didNotSyncedRecords.map(function (item) {
          var newrecord = Caml_obj.obj_dup(item);
          return tx.store.put((newrecord.sync = true, newrecord));
        });
    pstores.push(tx.done);
    await Promise.all(pstores);
  }
  return sendResponse(true);
}

async function recordDeleteManyMessageHandler(recordType, msg, sendResponse) {
  var db = await dbInstance;
  var tx = db.transaction(recordType, "readwrite");
  var pstores = msg.records.map(function (item) {
        return tx.store.delete(item.date);
      });
  pstores.push(tx.done);
  await Promise.all(pstores);
  await Utils.recordRemoteAction(recordType, {
        text: msg.records.map(function (v) {
              return v.text;
            })
      }, "delete");
  return sendResponse(false);
}

async function recordMessageHandler(recordType, extraAction, sendResponse) {
  if (extraAction === "GetAll") {
    var db = await dbInstance;
    var retFromLocals = await db.getAllFromIndex(recordType, "text");
    return sendResponse(retFromLocals);
  }
  var db$1 = await dbInstance;
  await db$1.clear(recordType);
  return sendResponse(undefined);
}

async function historyAddMessageHandler(msg, sender, sendResponse) {
  var db = await dbInstance;
  var mText = msg.text;
  var tab = getBrowserTab(sender);
  var data_url = tab.url;
  var data_title = tab.title;
  var data_favIconUrl = tab.favIconUrl;
  var data_date = Date.now();
  var data = {
    url: data_url,
    title: data_title,
    favIconUrl: data_favIconUrl,
    date: data_date,
    text: mText
  };
  var ret = await db.getFromIndex("history", "text", mText);
  var match = !ret;
  if (match) {
    await db.add("history", data, undefined);
    await Utils.recordRemoteAction("history", data, undefined);
  }
  return sendResponse(undefined);
}

chrome.runtime.onMessage.addListener(function (message, sender, sendResponse) {
      switch (message.TAG) {
        case "TranslateMsgContent" :
            translateMessageHandler(message._0, sendResponse);
            break;
        case "FavAddMsgContent" :
            favAddMessageHandler(message._0, sender, sendResponse);
            break;
        case "FavAddManyMsgContent" :
            recordAddManyMessageHandler("favorite", message._0, sendResponse);
            break;
        case "FavGetOneMsgContent" :
            favGetOneMessageHandler(message._0, sendResponse);
            break;
        case "FavDeleteOneMsgContent" :
            favDeleteOneMessageHandler(message._0, sendResponse);
            break;
        case "FavDeleteManyMsgContent" :
            recordDeleteManyMessageHandler("favorite", message._0, sendResponse);
            break;
        case "FavExtraMsgContent" :
            recordMessageHandler("favorite", message._0, sendResponse);
            break;
        case "HistoryAddMsgContent" :
            historyAddMessageHandler(message._0, sender, sendResponse);
            break;
        case "HistoryAddManyMsgContent" :
            recordAddManyMessageHandler("history", message._0, sendResponse);
            break;
        case "HistoryDeleteManyMsgContent" :
            recordDeleteManyMessageHandler("history", message._0, sendResponse);
            break;
        case "HistoryExtraMsgContent" :
            recordMessageHandler("history", message._0, sendResponse);
            break;
        
      }
      return true;
    });

export {
  getBrowserTab ,
  dbInstance ,
  translateMessageHandler ,
  favGetOneMessageHandler ,
  favAddMessageHandler ,
  favDeleteOneMessageHandler ,
  recordAddManyMessageHandler ,
  recordDeleteManyMessageHandler ,
  recordMessageHandler ,
  historyAddMessageHandler ,
}
/* dbInstance Not a pure module */
