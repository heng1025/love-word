import { defineConfig } from "vite";
import { resolve } from "path";

export default defineConfig({
  appType: "mpa",
  envPrefix: "LW_",
  build: {
    minify: !process.env.__DEV__,
    modulePreload: false,
    rollupOptions: {
      input: {
        popup: resolve(__dirname, "popup.html"),
        options: resolve(__dirname, "options.html"),
        background: resolve(__dirname, "src/Background.js"),
        content: resolve(__dirname, "src/content_scripts/ContentEntry.js"),
      },
      output: {
        manualChunks(id) {
          if (id.includes("node_modules")) {
            return "vendor";
          }
          if (id.includes("src/common.css") || id.includes("src/Utils")) {
            return "common";
          }
        },
        entryFileNames: (chunk) => {
          return "assets/[name].js";
        },
        assetFileNames: (asset) => {
          return "assets/[name].[ext]";
        },
        chunkFileNames: (chunk) => {
          return "assets/[name].js";
        },
      },
    },
  },
});
