const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const path = require('node:path');
const panel = fs.readFileSync(path.join(__dirname, '../Panel.qml'), 'utf8');
const start = panel.indexOf('  function applyBarLayout(text)');
const end = panel.indexOf('  function barSectionFor(id)', start);
assert.notEqual(start, -1);
assert.notEqual(end, -1);
const root = {};
const context = vm.createContext({ root, console, JSON });
vm.runInContext(panel.slice(start, end), context);
context.applyBarLayout(JSON.stringify({ bar: {
  layout: { right: [{ id: 'omarchy.tray' }], tray: [{ id: 'superwhisper.panel' }, 'omarchy.audio'] },
  pluginFolder: { widgets: [{ id: 'legacy.plugin' }] }
} }));
assert.deepEqual(JSON.parse(JSON.stringify(root.barLayoutCache)), {
  left: [], center: [], right: ['omarchy.tray'],
  folder: ['superwhisper.panel', 'omarchy.audio', 'legacy.plugin']
});
context.applyBarLayout(JSON.stringify({ bar: { layout: { tray: ['only.plugin'] } } }));
assert.deepEqual(Array.from(root.barLayoutCache.folder), ['only.plugin']);
console.log('drawer-layout-test: ok');
