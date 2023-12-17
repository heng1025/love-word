open Common
open Common.Http
open Common.Chrome

let apiHost = %raw(`import.meta.env.LW_API_HOST`)
let getSourceLang = text => FrancMin.createFranc(text, {minLength: 1, only: ["eng", "cmn"]})
let includeWith = (target, substring) => Js.Re.fromString(substring)->Js.Re.test_(target)

type api<'data> = {
  code: int,
  data: 'data,
  msg: string,
}
let fetchByHttp = async (~url, ~method="get", ~body=?) => {
  try {
    let headers = Js.Obj.empty()
    let result = await chromeStore->get(~keys=["user"])
    let user = result["user"]
    let _ = switch Js.toOption(user) {
    | Some(val) => Js.Obj.assign(headers, {"x-token": val["token"]})
    | _ => headers
    }

    let res = switch body {
    | Some(b) =>
      await fetch(
        ~input=`${apiHost}${url}`,
        ~init={method, headers, body: Js.Json.stringifyAny(b)},
        (),
      )
    | _ => await fetch(~input=`${apiHost}${url}`, ~init={headers: headers}, ())
    }
    let json: api<'data> = await Response.json(res)
    switch json.code {
    | 0 => Ok(json.data)
    | _ => Error(json.msg)
    }
  } catch {
  | Js.Exn.Error(err) =>
    switch Js.Exn.message(err) {
    | Some(msg) => Error(msg)
    | _ => Error("Err happen")
    }
  | _ => Error("Unexpected error occurred")
  }
}

let debounce = (delay, callback) => {
  let timeoutID = ref(Js.Nullable.null)
  let cancelled = ref(false)

  let clearExistingTimeout = () => {
    if !Js.Nullable.isNullable(timeoutID.contents) {
      Js.Nullable.iter(timeoutID.contents, timer => Js.Global.clearTimeout(timer))
    }
  }

  let cancel = () => {
    clearExistingTimeout()
    cancelled := true
  }
  let wrapper = () => {
    clearExistingTimeout()

    switch cancelled.contents {
    | false => timeoutID := Js.Nullable.return(Js.Global.setTimeout(() => {
            callback()
          }, delay))
    | _ => ()
    }
  }

  (wrapper, cancel)
}

