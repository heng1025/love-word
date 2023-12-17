import { defineConfig } from "vitest/config";

export default defineConfig({
  envPrefix: "LW_",
  test: {
    globals: true,
    include: ["tests/**/*Test.js"],
    setupFiles: './tests/utils/TestSetup.js',
    environment: 'happy-dom'
  },
})
