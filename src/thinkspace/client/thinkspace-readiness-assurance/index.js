/* jshint node: true */
'use strict';

module.exports = global.totem_engine_addon.extend({
  name: 'thinkspace-readiness-assurance',
  lazyLoading: false,
  isDevelopingAddon: function() {return true}  // see ember-cli issue #2451
});
