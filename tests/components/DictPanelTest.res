open TestBinding
open TestBinding.Vitest
open TestBinding.ReactTestingLibrary
open DictPanel
open Fixture

describe("DictPanel component", () => {
  let data = dictData

  test("renders correctly", () => {
    render(<DictPanel data />)->ignore
    let phonetic = screen->getByText("[ hә'lәu ]")
    let translation = screen->getByText("interj. 喂, 嘿")
    let tag = screen->getByText("zk")
    let tags = screen->getAllByRole("mark")

    expect(phonetic)->toBeInTheDocument
    expect(translation)->toBeInTheDocument
    expect(tag)->toBeInTheDocument
    expect(tags)->toHaveLength(2)
  })

  test("renders empty", () => {
    let mutData = {...data, translation: "", phonetic: "", tag: ""}
    render(<DictPanel data=mutData />)->ignore
    let phonetic = screen->queryByText("[ hә'lәu ]")
    let translation = screen->queryByText("interj. 喂, 嘿")
    let tag = screen->queryByText("zk")
    let tags = screen->queryAllByRole("mark")

    expect(phonetic)->notAtTest->toBeInTheDocument
    expect(translation)->notAtTest->toBeInTheDocument
    expect(tag)->notAtTest->toBeInTheDocument
    expect(tags)->toHaveLength(0)
  })

  test("click phonetic button", async () => {
    render(<DictPanel data />)->ignore
    let speaker = screen->getByTestId("play")
    expect(speaker)->notAtTest->toHaveClass("animate-fadeInOut-200ms")
    let user = userEvent->setup
    await user->click(speaker)
    expect(speaker)->toHaveClass("animate-fadeInOut-200ms")
    await user->click(speaker)
    expect(speaker)->notAtTest->toHaveClass("animate-fadeInOut-200ms")
  })

  test("phonetic play / ended event", async () => {
    let mutData = {...data, translation: "", tag: ""}
    render(<DictPanel data=mutData />)->ignore
    let speaker = screen->getByTestId("play")
    let user = userEvent->setup
    await user->click(speaker)

    let mockAudioResults = self["Audio"]->mockResults
    let mockAudioInstance = mockAudioResults[0]["value"]

    expect(mockAudioInstance["play"])->toHaveBeenCalled()
    let onEndedSpy = vi->spyOn(mockAudioInstance, "onended")

    // `onended` event should be wrapped into act
    act(
      () => {
        mockAudioInstance["onended"]()->ignore
      },
    )

    expect(onEndedSpy)->toHaveBeenCalled()

    await waitForAtRTL(
      () => {
        expect(speaker)->notAtTest->toHaveClass("animate-fadeInOut-200ms")
      },
    )
  })
})
