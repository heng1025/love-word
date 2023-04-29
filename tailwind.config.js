/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{mjs,js,ts,jsx,tsx}"],
  plugins: [require("daisyui")],
  daisyui: {
    themes: ["light", "dark"],
  },
  theme: {
    extend: {
      animation: {
        "fadeInOut-200ms": "fadeInOut 0.8s infinite 0.2s",
        "fadeInOut-400ms": "fadeInOut 0.8s infinite 0.4s",
      },
      keyframes: {
        fadeInOut: {
          "0%": { opacity: 0 },
          "100%": { opacity: 1 },
        },
      },
    },
  },
};
