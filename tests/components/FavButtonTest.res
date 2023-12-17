open TestBinding.Vitest
open TestBinding.ReactTestingLibrary
open Utils
open Fixture
open Common.Chrome

let trans = Js.Nullable.return(BaiduT(baiduData))
let chromeSendMsgSpy = vi->spyOn(chromeRuntime, "sendMessage")

describe("FavButton component", () => {
  chromeSendMsgSpy->mockResolvedValueOnce(false)->ignore

  test("renders correctly", () => {
    render(<FavButton text="你好" trans />)->ignore
    let favBtn = screen->getByRole("button")
    expect(favBtn)->toBeInTheDocument
    let starTitle = screen->getByTitle("star")
    expect(starTitle)->toBeInTheDocument
  })

  test("can not add faved when text is empty", async () => {
    chromeSendMsgSpy->mockResolvedValueOnce(false)->ignore
    render(<FavButton text="" trans />)->ignore
    let favBtn = screen->getByRole("button")
    let user = userEvent->setup
    await user->click(favBtn)
    let starTitle = screen->getByTitle("star")
    expect(starTitle)->toBeInTheDocument
  })

  test("add/remove Faved when click button", async () => {
    chromeSendMsgSpy->mockResolvedValueOnce(true)->ignore
    render(<FavButton text="你好" trans />)->ignore
    let favBtn = screen->getByRole("button")
    let user = userEvent->setup
    await user->click(favBtn)
    let starFillTitle = screen->getByTitle("star-fill")
    expect(starFillTitle)->toBeInTheDocument
    chromeSendMsgSpy->mockResolvedValueOnce(false)->ignore
    await user->click(favBtn)
    let starTitle = screen->getByTitle("star")
    expect(starTitle)->toBeInTheDocument
  })
})
