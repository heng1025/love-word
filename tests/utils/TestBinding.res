// there is not a global window object in service worker
// self = window | globalThis | global
@val external self: 'a = "self"

module Vitest = {
  type vitestTest
  // globals: true is required (rescript doesn't support named import)
  @val external test: (string, 'fn) => unit = "test"
  @val external testTodo: 'a => unit = "test.todo"
  @val external testOnly: (string, 'fn) => unit = "test.only"
  @val external testSkip: (string, 'fn) => unit = "test.skip"
  @val external testEach: 'tuple => (string, 'fn) => unit = "test.each"
  @val external bench: (string, 'fn) => unit = "bench"
  @val external describe: (string, 'fn) => unit = "describe"
  @val external describeTodo: 'a => unit = "describe.todo"
  @val external describeOnly: (string, 'fn) => unit = "describe.only"
  @val external describeSkip: (string, 'fn) => unit = "describe.skip"
  @val external describeEach: 'tuple => (string, 'fn) => unit = "describe.each"
  @val external beforeEach: 'fn => unit = "beforeEach"
  @val external afterEach: 'fn => unit = "afterEach"
  @val external beforeAll: 'fn => unit = "beforeAll"
  @val external afterAll: 'fn => unit = "afterAll"

  // mock
  type vitest
  type vi
  type mockInstance
  @val
  external vi: vi = "vi"
  @send
  external fn: (vi, ~callback: 'a=?) => 'mockInstance = "fn"
  @send
  external mock: (vi, string, ~factory: 'm => promise<'a>=?) => unit = "mock"
  @send
  external doMock: (vi, string, ~factory: 'm => promise<'a>=?) => unit = "doMock"
  @send
  external mocked: (vi, 'a) => 'b = "mocked"
  @send
  external clearAllMocks: vi => unit = "clearAllMocks"
  @send
  external resetAllMocks: vi => unit = "resetAllMocks"
  @send
  external stubGlobal: (vi, 'k, 'v) => vitest = "stubGlobal"
  @send
  external spyOn: (vi, 'a, 'f) => 'mockInstance = "spyOn"
  @send
  external restoreAllMocks: vi => mockInstance = "restoreAllMocks"
  @send
  external mockClear: (mockInstance, 'a) => 'mockInstance = "mockClear"
  @send
  external mockReset: (mockInstance, 'a) => 'mockInstance = "mockReset"
  @send
  external mockRestore: mockInstance => 'mockInstance = "mockRestore"
  @send
  external mockReturnValue: (mockInstance, 'a) => 'mockInstance = "mockReturnValue"
  @send
  external mockReturnValueOnce: (mockInstance, 'a) => 'mockInstance = "mockReturnValueOnce"
  @send
  external mockResolvedValue: (mockInstance, 'a) => 'mockInstance = "mockResolvedValue"
  @send
  external mockResolvedValueOnce: (mockInstance, 'a) => 'mockInstance = "mockResolvedValueOnce"
  @send
  external mockImplementation: (mockInstance, 'a) => 'mockInstance = "mockImplementation"
  @send
  external getMockImplementation: mockInstance => 'a = "getMockImplementation"
  @scope("mock") @get
  external mockInstances: mockInstance => array<'a> = "instances"
  @scope("mock") @get
  external mockResults: mockInstance => array<{"type": string, "value": 'a}> = "results"

  // fake timer
  @send
  external advanceTimersByTime: (vi, int) => vitest = "advanceTimersByTime"
  @send
  external advanceTimersByTimeAsync: (vi, int) => promise<vitest> = "advanceTimersByTimeAsync"
  @send
  external advanceTimersToNextTimer: vi => vitest = "advanceTimersToNextTimer"
  @send
  external advanceTimersToNextTimerAsync: vi => promise<vitest> = "advanceTimersToNextTimerAsync"
  @send
  external runAllTimers: vi => vitest = "runAllTimers"
  @send
  external runOnlyPendingTimers: vi => vitest = "runOnlyPendingTimers"
  @send
  external useFakeTimers: vi => vitest = "useFakeTimers"
  @send
  external useRealTimers: vi => vitest = "useRealTimers"

  // miscellaneous
  @send
  external waitFor: (vi, 'callback) => promise<'a> = "waitFor"
  @send
  external waitUntil: (vi, 'callback) => promise<'a> = "waitUntil"

  // expect
  type expect
  @val
  external expect: 'a => expect = "expect"
  @get
  external notAtTest: expect => expect = "not"
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
  external toStrictEqual: (expect, 'a) => unit = "toStrictEqual"
  @send
  external toHaveReturned: (expect, unit) => unit = "toHaveReturned"
  @send
  external toHaveReturnedWith: (expect, 'a) => unit = "toHaveReturnedWith"
  @send
  external toHaveBeenCalled: (expect, unit) => unit = "toHaveBeenCalled"
  @send @variadic
  external toHaveBeenCalledWith: (expect, array<'a>) => unit = "toHaveBeenCalledWith"
  @send
  external toHaveLength: (expect, int) => unit = "toHaveLength"
  @send
  external resolves: expect => expect = "resolves"

  // jest-dom
  @send
  external toBeInTheDocument: expect => unit = "toBeInTheDocument"
  @send
  external toHaveClass: (expect, string) => unit = "toHaveClass"
  @send
  external toHaveValue: (expect, 'a) => unit = "toHaveValue"
}
