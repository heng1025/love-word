open TestBinding.Vitest
open Background
open Utils
open Fixture

// just import utils module
let _ = Utils.adapterTrans

// Type Cast (mock)
@val external adapterTransMock: mockInstance = "Utils.adapterTrans"

let mockOpenDB: mockInstance = Common.Idb.mockOpenDB

vi->mock("idb")

// just mock adapterTrans
let factory = async importOriginal => {
  let mod = await importOriginal()
  let copy = Js.Obj.assign(Js.Obj.empty(), mod)

  copy["adapterTrans"] = vi->fn
  copy
}

vi->mock("../src/Utils.js", ~factory)

// mock fav/history records from server
chromeGetStoreSpy->mockReturnValue({"user": "iron"})->ignore

let sender = {
  "origin": "",
  "url": "",
  "tab": None,
}

let textMsgContent = {text: "hello"}

let recordsMsgContent = {
  records: [
    {
      text: "hello",
      date: 1702448855816.0,
    },
  ],
}

let translateSuite = () => {
  // Redundant testing
  test("translateMessageHandler works", async () => {
    adapterTransMock->mockResolvedValue("你好")->ignore

    let mockSendResponse = vi->fn
    await translateMessageHandler(textMsgContent, mockSendResponse)
    expect(mockSendResponse)->toHaveBeenCalledWith(["你好"])
  })

  test("translation message", async () => {
    // adapterTransMock->mockResolvedValue("你好")->ignore

    let mockSendResponse = vi->fn
    let result = handleMessage(TranslateMsgContent(textMsgContent), sender, mockSendResponse)
    expect(result)->toBe(true)

    await vi->waitFor(() => {
      expect(mockSendResponse)->toHaveBeenCalledWith(["你好"])
    })
  })
}

let favoriteSuite = () => {
  test("word already exists in favorites", async () => {
    mockOpenDB
    ->mockResolvedValue({
      "getFromIndex": vi->fn->mockResolvedValue(true),
    })
    ->ignore
    let mockSendResponse = vi->fn
    let result = handleMessage(FavGetOneMsgContent(textMsgContent), sender, mockSendResponse)
    expect(result)->toBe(true)

    await vi->waitFor(() => {
      expect(mockSendResponse)->toHaveBeenCalledWith([true])
    })
  })

  test("add a word to favorites", async () => {
    mockOpenDB
    ->mockResolvedValue({
      "add": vi->fn->mockResolvedValue(),
    })
    ->ignore
    let favAddMsgContent = {
      text: "hello",
      translation: Js.Nullable.return(BaiduT(baiduData)),
    }
    let mockSendResponse = vi->fn
    let result = handleMessage(FavAddMsgContent(favAddMsgContent), sender, mockSendResponse)
    expect(result)->toBe(true)

    await vi->waitFor(() => {
      expect(mockSendResponse)->toHaveBeenCalledWith([true])
    })
  })

  test("add many words to favorites", async () => {
    mockOpenDB
    ->mockResolvedValue({
      "add": vi->fn->mockResolvedValue(),
    })
    ->ignore

    let words = {
      ...dictRecord,
      sync: true,
    }
    let mockSendResponse = vi->fn
    let result = handleMessage(FavAddManyMsgContent([words]), sender, mockSendResponse)
    expect(result)->toBe(true)

    await vi->waitFor(() => {
      expect(mockSendResponse)->toHaveBeenCalledWith([true])
    })
  })

  test("delete a word to favorites", async () => {
    mockOpenDB
    ->mockResolvedValue({
      "getKeyFromIndex": vi->fn->mockResolvedValue(1),
      "delete": vi->fn->mockResolvedValue(),
    })
    ->ignore

    let mockSendResponse = vi->fn
    let result = handleMessage(FavDeleteOneMsgContent(textMsgContent), sender, mockSendResponse)
    expect(result)->toBe(true)

    await vi->waitFor(() => {
      expect(mockSendResponse)->toHaveBeenCalledWith([false])
    })
  })

  test("delete many words to favorites", async () => {
    let mockTransaction = {
      "done": vi->fn->mockResolvedValue(),
      "store": {
        "delete": vi->fn->mockResolvedValue(),
      },
    }
    mockOpenDB
    ->mockResolvedValue({
      "delete": vi->fn->mockResolvedValue(),
      "transaction": vi->fn->mockReturnValue(mockTransaction),
    })
    ->ignore
    let mockSendResponse = vi->fn
    let result = handleMessage(FavDeleteManyMsgContent(recordsMsgContent), sender, mockSendResponse)
    expect(result)->toBe(true)

    await vi->waitFor(() => {
      expect(mockSendResponse)->toHaveBeenCalledWith([false])
    })
  })

  test("get all words from favorites", async () => {
    mockOpenDB
    ->mockResolvedValue({
      "getAllFromIndex": vi->fn->mockResolvedValue(["hello"]),
    })
    ->ignore

    let mockSendResponse = vi->fn
    let result = handleMessage(FavExtraMsgContent(GetAll), sender, mockSendResponse)
    expect(result)->toBe(true)

    await vi->waitFor(() => {
      expect(mockSendResponse)->toHaveBeenCalledWith([["hello"]])
    })
  })

  test("clear all words in favorites", async () => {
    mockOpenDB
    ->mockResolvedValue({
      "clear": vi->fn->mockResolvedValue(),
    })
    ->ignore

    let mockSendResponse = vi->fn
    let result = handleMessage(FavExtraMsgContent(Clear), sender, mockSendResponse)
    expect(result)->toBe(true)

    await vi->waitFor(() => {
      expect(mockSendResponse)->toHaveBeenCalled()
    })
  })
}

let historySuite = () => {
  test("add a word to history", async () => {
    mockOpenDB
    ->mockResolvedValue({
      "getFromIndex": vi->fn->mockResolvedValue(false),
      "add": vi->fn->mockResolvedValue(),
    })
    ->ignore

    let mockSendResponse = vi->fn
    let result = handleMessage(HistoryAddMsgContent(textMsgContent), sender, mockSendResponse)
    expect(result)->toBe(true)

    await vi->waitFor(() => {
      expect(mockSendResponse)->toHaveBeenCalled()
    })
  })
}

describe("Background service", () => {
  afterEach(() => {
    vi->clearAllMocks
  })

  test("browser tab information", () => {
    let tab = getBrowserTab(sender)
    expect(tab["title"])->toBe("Love Word")

    let copySender = Js.Obj.assign(Js.Obj.empty(), sender)
    copySender["tab"] = Some({"url": "1r21.cn"})
    let tab = getBrowserTab(copySender)
    expect(tab["url"])->toBe("1r21.cn")
  })

  describe("Translation message", translateSuite)
  describe("Favorites message", favoriteSuite)
  describe("History message", historySuite)
})
