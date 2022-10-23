/**
 * @type {import('postcss').PluginCreator}
 */
module.exports = (opts = {}) => {
  return {
    postcssPlugin: "replace-root",
    Rule(rule) {
      rule.selector = rule.selector.replace(/:root/, ":root,:host");
    },
  };
};

module.exports.postcss = true;
