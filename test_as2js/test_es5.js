var assert = require("assert");
var es5 = require("./es5.js");

var assert = "undefined" != typeof assert ? assert : {equal: function(e, g){if (e !== g) console.log(e, g)}}
var c = new es5.C();
assert.equal("true", c.a.toString());
assert.equal("i", c.instance);
c.f(2);
assert.equal(1, c.x);
