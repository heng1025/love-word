import fs from "node:fs";
import { resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { build, mergeConfig } from "vite";

import genManifest from "../plugins/gen-manifest.mjs";

const __dirname = fileURLToPath(new URL("..", import.meta.url));
const enableDev = process.argv.includes("--dev");
const outDir = "dist";
const baseConfig = {
  configFile: false,
  envPrefix: "LW_",
  define: {
    // inject content css
    __CONTENT_CSS__: JSON.stringify("assets/lw.common.css"),
  },
  plugins: [genManifest(outDir)],
  build: {
    outDir,
    emptyOutDir: false,
    sourcemap: enableDev,
    watch: enableDev,
  },
};

run();

async function run() {
  fs.rmSync(resolve(__dirname, outDir), { recursive: true, force: true });
  await Promise.all([buildContentScript(), buildPages()]);
}

async function buildContentScript() {
  const contentScriptConfig = mergeConfig(baseConfig, {
    build: {
      rollupOptions: {
        input: resolve(__dirname, "src/content_scripts/ContentEntry.js"),
        output: {
          entryFileNames: "pages/content_scripts.js",
        },
      },
    },
  });
  return build(contentScriptConfig);
}

async function buildPages() {
  const input = {
    popup: resolve(__dirname, "popup.html"),
    options: resolve(__dirname, "options.html"),
    background: resolve(__dirname, "src/Background.js"),
  };

  const pageConfig = mergeConfig(baseConfig, {
    build: {
      rollupOptions: {
        input,
        output: {
          entryFileNames: (chunkInfo) => {
            const { name } = chunkInfo;
            if (name !== "background" && !enableDev) {
              return "pages/[name].[hash].js";
            }
            return "pages/[name].js";
          },
          manualChunks(id) {
            if (id.includes("node_modules")) {
              return "vendor";
            }
          },
          chunkFileNames: (chunkInfo) => {
            const { name } = chunkInfo;
            const newChunkName = upperCase2LowerCaseDot(name);
            if (enableDev) {
              return `assets/${newChunkName}.js`;
            }
            return `assets/${newChunkName}.[hash].js`;
          },
          assetFileNames: () => {
            return "assets/lw.[name].[ext]";
          },
        },
      },
    },
  });
  return build(pageConfig);
}

function upperCase2LowerCaseDot(str) {
  return str.replace(/([a-zA-Z])([A-Z])/, "$1.$2").toLowerCase();
}
