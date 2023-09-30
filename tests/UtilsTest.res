open TestBinding.Vitest
open Utils
open Utils.OfflineDict

stubGlobal(
  vi,
  "chrome",
  {
    "storage": {
      "local": {
        "get": () => "",
      },
    },
  },
)->ignore

describe("Utils Lib", () => {
  test("fetchByHttp is ok", async () => {
    let res = await Lib.fetchByHttp(~url=`/dict?q=hello`)
    switch res {
    | Ok(val) => expect(val.word)->toBe("hello")
    | Error(msg) => expect(msg)->toBe("error")
    }
  })

  test("Baidu translate is ok", async () => {
    switch await Baidu.translate("hello") {
    | Ok(val) => expect(val)->toBe("hello")
    | Error(msg) => expect(msg)->toBe("No translation key")
    }
  })
})
