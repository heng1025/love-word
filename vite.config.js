import { defineConfig } from "vite";
import { resolve } from "path";
import genManifest from "./plugins/gen-manifest";
import manifest from "./manifest";

export default defineConfig({
  appType: "mpa",
  envPrefix: "LW_",
  plugins: [genManifest(manifest)],
  build: {
    minify: !process.env.__DEV__,
    modulePreload: false,
    rollupOptions: {
      input: {
        popup: resolve(__dirname, "popup.html"),
        options: resolve(__dirname, "options.html"),
        background: resolve(__dirname, "src/Background.js"),
        content: resolve(__dirname, "src/content_scripts/ContentLoader.js"),
      },
      output: {
        manualChunks(id) {
          if (id.includes("node_modules")) {
            return "vendor";
          }
        },
        entryFileNames: (chunk) => {
          return "pages/[name].js";
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
