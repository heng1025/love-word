open TestBinding.Vitest
open Utils.OfflineDict
open Utils.Lib

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
  test("fetchByHttp", async () => {
    let res = await fetchByHttp(~url=`/dict?q=hello`)
    switch res {
    | Ok(val) => expect(val.word)->toBe("hello")
    | Error(msg) => expect(msg)->toBe("error")
    }
  })
})
