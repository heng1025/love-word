import fs from "node:fs";
import path from "node:path";

const { resolve } = path;

const outDir = resolve(__dirname, "..", "public");

export default function genManifest(manifest) {
  return {
    name: "gen-manifest",
    buildEnd() {
      if (!fs.existsSync(outDir)) {
        fs.mkdirSync(outDir);
      }

      const manifestPath = resolve(outDir, "manifest.json");

      fs.writeFileSync(manifestPath, JSON.stringify(manifest, null, 2));

      console.log(`\nManifest file copy complete: ${manifestPath}`, "success");
    },
  };
}
