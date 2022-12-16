/**
 * @type {import('postcss').PluginCreator}
 */
module.exports = (opts = { baseValue: 16 }) => {
  return {
    postcssPlugin: "replace-root",
    Rule(rule) {
      // Declaration will fire this
      if (/:root/.test(rule.selector) && !/:host/.test(rule.selector)) {
        rule.selector = rule.selector.replace(/^(:root),?/, "$1,:host");
      }
    },
    // rem->px (content script rem is controlled by outside html)
    Declaration(decl) {
      const unit = "px";
      const re = /"[^"]+"|'[^']+'|url\([^)]+\)|(-?\d*\.?\d+)rem/g;
      decl.value = decl.value.replace(re, (match, p1) => {
        if (p1 === undefined) return match;

        return `${p1 * opts.baseValue}${p1 == 0 ? "" : unit}`;
      });
    },
  };
};

module.exports.postcss = true;
