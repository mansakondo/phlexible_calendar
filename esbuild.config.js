#!/usr/bin/env node

const rails = require("esbuild-rails");

require("esbuild").build({
  entryPoints: ["app/javascript/application.js"],
  outdir: "app/assets/builds/phlexible_calendar",
  bundle: true,
  plugins: [
    rails(),
  ],
  watch: {
    onRebuild: (err, result) => {
      if (err) console.log("Watch build failed: ", err)
      else console.log("Watch build succeeded", result);
    },
  },
}).then(result => {
  console.log("Watching...");
})
