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

module ReactTestingLibrary = {
  open Common.Webapi.Window
  type renderResult
  type queries
  type props = {children: React.element}
  type renderOptions = {
    container: Js.undefined<Dom.element>,
    baseElement: Js.undefined<Dom.element>,
    hydrate: Js.undefined<bool>,
    wrapper: Js.undefined<props => React.element>,
    queries: Js.undefined<queries>,
  }

  // hook
  type renderHookResult
  type hookResult
  @module("@testing-library/react")
  external renderHook: 'a => renderHookResult = "renderHook"
  @send
  external renderHookRerender: renderHookResult => unit = "rerender"
  @send
  external renderHookUnmount: renderHookResult => unit = "unmount"
  @get
  external renderHookResult: renderHookResult => hookResult = "result"
  @get
  external renderHookResultCurrent: hookResult => 'a = "current"

  // other
  @module("@testing-library/react")
  external act: 'a => unit = "act"
  @module("@testing-library/react")
  external promiseAct: 'a => promise<unit> = "act"
  @module("@testing-library/react")
  external cleanup: unit => unit = "cleanup"
  @module("@testing-library/react")
  external waitForAtRTL: ('callback, ~opts: 'a=?) => promise<unit> = "waitFor"
  @module("@testing-library/react")
  external fireEvent: (Dom.element, cusEvent) => unit = "fireEvent"
  @module("@testing-library/react")
  external // render
  screen: renderResult = "screen"
  @module("@testing-library/react")
  external logRoles: Dom.element => unit = "logRoles"
  @module("@testing-library/react")
  external _render: (React.element, renderOptions) => renderResult = "render"
  @send
  external debug: renderResult => unit = "debug"
  @get
  external container: renderResult => Dom.element = "container"
  @get
  external baseElement: renderResult => Dom.element = "baseElement"
  @send
  external unmount: (renderResult, unit) => bool = "unmount"
  @send
  external rerender: (renderResult, React.element) => unit = "rerender"

  let render = (element, ~baseElement=?, ~container=?, ~hydrate=?, ~wrapper=?, ~queries=?) => {
    let baseElement_ = switch container {
    | Some(container') => Js.Undefined.return(container')
    | None => Js.Undefined.fromOption(baseElement)
    }
    let container_ = Js.Undefined.fromOption(container)

    _render(
      element,
      {
        baseElement: baseElement_,
        container: container_,
        hydrate: Js.Undefined.fromOption(hydrate),
        wrapper: Js.Undefined.fromOption(wrapper),
        queries: Js.Undefined.fromOption(queries),
      },
    )
  }

  // custom render
  let wraperRender = element => {
    render(element, ~wrapper=({children}) => children)
  }

  // ByTestId
  @send
  external getByTestId: (renderResult, string, ~opts: 'a=?) => Dom.element = "getByTestId"
  @send
  external queryByTestId: (renderResult, string, ~opts: 'a=?) => Dom.element = "queryByTestId"
  @send
  external findByTestId: (renderResult, string, ~opts: 'a=?) => promise<Dom.element> =
    "findByTestId"
  @send
  external getAllByTestId: (renderResult, string, ~opts: 'a=?) => Dom.element = "getAllByTestId"
  @send
  external queryAllByTestId: (renderResult, string, ~opts: 'a=?) => Dom.element = "queryAllByTestId"
  @send
  external findAllByTestId: (renderResult, string, ~opts: 'a=?) => promise<Dom.element> =
    "findAllByTestId"

  // ByDisplayValue
  @send
  external getByDisplayValue: (renderResult, string, ~opts: 'a=?) => Dom.element =
    "getByDisplayValue"
  @send
  external getAllByDisplayValue: (renderResult, string, ~opts: 'a=?) => array<Dom.element> =
    "getByDisplayValue"

  // ByPlaceholderText
  @send
  external getByPlaceholderText: (renderResult, string, ~opts: 'a=?) => Dom.element =
    "getByPlaceholderText"
  @send
  external queryByPlaceholderText: (renderResult, string, ~opts: 'a=?) => Dom.element =
    "queryByPlaceholderText"
  @send
  external findByPlaceholderText: (renderResult, string, ~opts: 'a=?) => promise<Dom.element> =
    "findByPlaceholderText"
  @send
  external getAllByPlaceholderText: (renderResult, string, ~opts: 'a=?) => array<Dom.element> =
    "getAllByPlaceholderText"
  @send
  external queryAllByPlaceholderText: (renderResult, string, ~opts: 'a=?) => array<Dom.element> =
    "queryAllByPlaceholderText"
  @send
  external findAllByPlaceholderText: (
    renderResult,
    string,
    ~opts: 'a=?,
  ) => promise<array<Dom.element>> = "findAllByPlaceholderText"

  // ByLabelText
  @send
  external getByLabelText: (renderResult, string, ~opts: 'a=?) => Dom.element = "getByLabelText"
  @send
  external getAllByLabelText: (renderResult, string, ~opts: 'a=?) => array<Dom.element> =
    "getAllByLabelText"

  // ByText
  @send
  external getByText: (renderResult, string, ~opts: 'a=?) => Dom.element = "getByText"
  @send
  external queryByText: (renderResult, string, ~opts: 'a=?) => Dom.element = "queryByText"
  @send
  external findByText: (renderResult, string, ~opts: 'a=?) => promise<Dom.element> = "findByText"
  @send
  external getAllByText: (renderResult, string, ~opts: 'a=?) => array<Dom.element> = "getAllByText"
  @send
  external queryAllByText: (renderResult, string, ~opts: 'a=?) => array<Dom.element> =
    "queryAllByText"
  @send
  external findAllByText: (renderResult, string, ~opts: 'a=?) => promise<array<Dom.element>> =
    "findAllByText"

  // ByRole (https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles)
  @send
  external getByRole: (renderResult, string, ~opts: 'a=?) => Dom.element = "getByRole"
  @send
  external queryByRole: (renderResult, string, ~opts: 'a=?) => Dom.element = "queryByRole"
  @send
  external findByRole: (renderResult, string, ~opts: 'a=?) => promise<Dom.element> = "findByRole"
  @send
  external getAllByRole: (renderResult, string, ~opts: 'a=?) => array<Dom.element> = "getAllByRole"
  @send
  external queryAllByRole: (renderResult, string, ~opts: 'a=?) => array<Dom.element> =
    "queryAllByRole"
  @send
  external findAllByRole: (renderResult, string, ~opts: 'a=?) => promise<array<Dom.element>> =
    "findAllByRole"

  // ByTitle
  @send
  external getByTitle: (renderResult, string, ~opts: 'a=?) => Dom.element = "getByTitle"
  @send
  external queryByTitle: (renderResult, string, ~opts: 'a=?) => Dom.element = "queryByTitle"
  @send
  external findByTitle: (renderResult, string, ~opts: 'a=?) => promise<Dom.element> = "findByTitle"
  @send
  external getAllByTitle: (renderResult, string, ~opts: 'a=?) => Dom.element = "getAllByTitle"
  @send
  external queryAllByTitle: (renderResult, string, ~opts: 'a=?) => Dom.element = "queryAllByTitle"
  @send
  external findAllByTitle: (renderResult, string, ~opts: 'a=?) => Dom.element = "findAllByTitle"

  // user event
  type userEvent
  type userSetup
  @module("@testing-library/user-event")
  external userEvent: userEvent = "userEvent"
  @send
  external setup: (userEvent, ~opts: 'a=?) => userSetup = "setup"
  @send
  external clear: (userSetup, Dom.element) => promise<unit> = "clear"
  @send
  external click: (userSetup, Dom.element) => promise<unit> = "click"
  @send
  external dblClick: (userSetup, Dom.element) => promise<unit> = "dblClick"
  @send
  external type_: (userSetup, Dom.element, string) => promise<unit> = "type"
}
