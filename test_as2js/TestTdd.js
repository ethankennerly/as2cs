var assert = require('assert');

/**
 * @author Ethan Kennerly
 */
suite('TestTdd', function()
{
  test('OneEqualsTwo', function()
  {
    var one = 1;
    assert.equal(1, one);
    assert.equal(2, one);
  });
});
