@val
external chrome: 'a = "chrome"

module Vitest = {
  @module("vitest") external test: (string, 'a) => unit = "test"
  @module("vitest") external bench: (string, 'a) => unit = "bench"
  @module("vitest") external describe: (string, 'a) => unit = "describe"
  @module("vitest") external beforeEach: 'a => promise<unit> = "beforeEach"
  @module("vitest") external afterEach: 'a => promise<unit> = "afterEach"
  @module("vitest") external beforeAll: 'a => promise<unit> = "beforeAll"
  @module("vitest") external afterAll: 'a => promise<unit> = "afterAll"

  type expect
  @module("vitest")
  external expect: 'a => expect = "expect"
  @send
  external toBe: (expect, 'a) => unit = "toBe"
  @send
  external toBeTruthy: (expect, unit) => unit = "toBeTruthy"
  @send
  external toBeFalsy: (expect, unit) => unit = "toBeFalsy"
  @send
  external toBeNull: (expect, unit) => unit = "toBeNull"
  @send
  external toEqual: (expect, 'a) => unit = "toEqual"
  @send
  external toHaveBeenCalled: (expect, unit) => unit = "toHaveBeenCalled"
  @send @variadic
  external toHaveBeenCalledWith: (expect, array<'a>) => unit = "toHaveBeenCalledWith"
  @send
  external toHaveReturned: (expect, unit) => unit = "toHaveReturned"
  @send
  external toHaveReturnedWith: (expect, 'a) => unit = "toHaveReturnedWith"
  @send
  external resolves: expect => expect = "resolves"

  type vitest
  type vi
  type callableMockInstance
  type mockInstance
  @module("vitest")
  external vi: vi = "vi"
  @send
  external fn: (vi, 'a) => callableMockInstance = "fn"
  @send
  external mock: (vi, string, 'a) => 'b = "mock"
  @send
  external stubGlobal: (vi, 'k, 'v) => vitest = "stubGlobal"
  @send
  external spyOn: (vi, 'a, 'f) => mockInstance = "spyOn"
  @send
  external mockReturnValue: (callableMockInstance, 'a) => mockInstance = "mockReturnValue"
}
