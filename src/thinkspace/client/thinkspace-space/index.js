/*jshint node:true*/

module.exports = global.totem_engine_addon.extend({
  name: 'thinkspace-space',
  lazyLoading: false,
  isDevelopingAddon: function() {return true}  // see ember-cli issue #2451
});
