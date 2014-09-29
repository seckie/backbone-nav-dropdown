describe('Simple Object', function() {
  var foo;
  foo = null;
  beforeEach(function() {
    loadFixture('');
    return foo = new $.NavDropdown();
  });
  return it('should say hi', function() {
    return expect(foo.sayHi()).toEqual('John say hi');
  });
});
