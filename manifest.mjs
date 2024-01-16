import { createRequire } from "node:module";

const require = createRequire(import.meta.url);
const pkg = require("./package.json");

const { name, version, description } = pkg;
const replacer = (match) => match.replace('-', ' ').toUpperCase()

export default {
  name: name.replace(/(^|-)\w/g, replacer),
  version,
  description,
  manifest_version: 3,
  icons: {
    16: "icons/lw16x16.png",
    32: "icons/lw32x32.png",
    48: "icons/lw48x48.png",
    128: "icons/lw128x128.png",
  },
  options_page: "options.html",
  action: {
    default_title: "Love Word",
    default_popup: "popup.html",
  },
  background: {
    service_worker: "pages/background.js",
    type: "module",
  },
  content_scripts: [
    {
      matches: ["<all_urls>"],
      js: ["pages/content_scripts.js"],
    },
  ],
  web_accessible_resources: [
    {
      matches: ["<all_urls>"],
      resources: ["images/*.jpeg", "assets/*.css", "assets/*.js"],
    },
  ],
  permissions: ["storage"],
};
