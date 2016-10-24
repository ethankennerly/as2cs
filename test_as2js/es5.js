"use strict";

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var C = function () {
  function C() {
    _classCallCheck(this, C);

    this.instance = "i";

    this.a = true;
  }

  _createClass(C, [{
    key: "f",
    value: function f(x) {
      var y = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 1;

      this.x = y;
    }
  }], [{
    key: "g",
    value: function g() {}
  }]);

  return C;
}();

exports.C = C;

