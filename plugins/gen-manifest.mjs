import fs from "node:fs";
import { resolve } from "node:path";

import manifest from "../manifest.mjs";

export default function genManifest(outDir) {
  return {
    name: "gen-manifest",
    buildEnd() {
      if (!fs.existsSync(outDir)) {
        fs.mkdirSync(outDir);
      }
      const manifestPath = resolve(outDir, "manifest.json");
      // only generate once
      if (!fs.existsSync(manifestPath)) {
        fs.writeFileSync(manifestPath, JSON.stringify(manifest, null, 2));
        console.log("\nManifest file generation complete.\n");
      }
    },
  };
}
