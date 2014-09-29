describe('Simple Object', () ->
  foo = null 
  beforeEach(() ->
    loadFixture('')
    foo = new $.NavDropdown()
  )
  it('should say hi', () ->
    expect(foo.sayHi()).toEqual('John say hi')
  )
)
