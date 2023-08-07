import { defineConfig } from "vitest/config";

export default defineConfig({
  envPrefix: "LW_",
  test: {
    include: ["tests/**/*Test.js"],
    environment: 'happy-dom'
  },
})
