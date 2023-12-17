open TestBinding.Vitest
open TestBinding.ReactTestingLibrary
open MachineTPanel
open TranSource.Baidu
open Fixture

describe("MachineTpanel component", () => {
  let data: array<baiduOk> = baiduData

  test("renders correctly", () => {
    render(<MachineTPanel data />)->ignore
    let translation = screen->getByText("hello")
    let playBtn = screen->getByRole("button")
    expect(translation)->toBeInTheDocument
    expect(playBtn)->toBeInTheDocument
  })

  test("play button works", async () => {
    open Common.Webapi.Window
    render(<MachineTPanel data />)->ignore
    let speaker = screen->getByTestId("play")
    let user = userEvent->setup
    await user->click(speaker)
    expect(speaker)->toHaveClass("animate-fadeInOut-200ms")
    let audioElement = screen->getByTestId("audioPlayer")

    fireEvent(audioElement, createEvent("ended"))

    await waitForAtRTL(
      () => {
        expect(speaker)->notAtTest->toHaveClass("animate-fadeInOut-200ms")
      },
    )
  })
})
