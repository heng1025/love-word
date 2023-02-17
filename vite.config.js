import { defineConfig } from "vite";
import { resolve } from "path";
import genManifest from "./plugins/gen-manifest";
import manifest from "./manifest";

const isDev = process.env.__DEV__ === "true";

export default defineConfig({
  appType: "mpa",
  envPrefix: "LW_",
  define: {
    // inject content css
    __CONTENT_CSS__: JSON.stringify("assets/lw.common.css"),
  },
  plugins: [genManifest(manifest)],
  build: {
    minify: !isDev,
    modulePreload: false,
    rollupOptions: {
      input: {
        popup: resolve(__dirname, "popup.html"),
        options: resolve(__dirname, "options.html"),
        background: resolve(__dirname, "src/Background.js"),
        content: resolve(__dirname, "src/content_scripts/ContentLoader.js"),
      },
      output: {
        entryFileNames: "pages/[name].js",
        manualChunks(id) {
          if (id.includes("node_modules")) {
            return "vendor";
          }
        },
        chunkFileNames: (chunk) => {
          const { name } = chunk;
          const newChunkName = upperCase2LowerCaseDot(name);
          if (isDev) {
            return `assets/lw.${newChunkName}.js`;
          }
          return `assets/lw.${newChunkName}.[hash].js`;
        },
        assetFileNames: (asset) => {
          return "assets/lw.[name].[ext]";
        },
      },
    },
  },
});

function upperCase2LowerCaseDot(str) {
  return str.replace(/([a-zA-Z])([A-Z])/, "$1.$2").toLowerCase();
}
