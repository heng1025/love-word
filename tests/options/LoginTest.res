open TestBinding.Vitest
open TestBinding.ReactTestingLibrary

let onSubmit = vi->fn
let onCancel = vi->fn
describe("Login Modal", () => {
  test("render correctly", () => {
    render(<Login onSubmit onCancel />)->ignore
    let modalTitle = screen->getByText("Login")
    expect(modalTitle)->toBeInTheDocument
  })

  testTodo("Username")
  testTodo("Password")
  testTodo("Submit")
  testTodo("Cancel")
})
