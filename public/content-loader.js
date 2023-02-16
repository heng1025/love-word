// https://stackoverflow.com/questions/48104433

(function () {
  "use strict";
  (async () => {
    const src = chrome.runtime.getURL("src/content.js");
    await import(src);
  })().catch(console.error);
})();
