require.define({
"ns1/file1": function(exports, require, module) {
  var name = 'file1';
console.log('Module name: ' + name);
},
"ns1/file2": function(exports, require, module) {
  var name = 'file2';
console.log('Module name: ' + name);
},
"ns2/file3": function(exports, require, module) {
  var name = 'file3';
console.log('Module name: ' + name);
},
"ns2/file4": function(exports, require, module) {
  var name = 'file4';
console.log('Module name: ' + name);
}
});