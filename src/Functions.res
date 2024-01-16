open Common
open Common.Http
open Common.Chrome

let apiHost = %raw(`import.meta.env.LW_API_HOST`)
let getSourceLang = text => FrancMin.createFranc(text, {minLength: 1, only: ["eng", "cmn"]})
let includeWith = (target, substring) => Re.fromString(substring)->RegExp.test(target)

type api<'data> = {
  code: int,
  data: 'data,
  msg: string,
}
let fetchByHttp = async (~url, ~method="get", ~body=?) => {
  try {
    let headers = Object.empty()
    let result = await chromeStore->get(~keys=["user"])
    let user = result["user"]
    let _ = switch Nullable.toOption(user) {
    | Some(val) => Object.assign(headers, {"x-token": val["token"]})
    | _ => headers
    }

    let res = switch body {
    | Some(b) =>
      await fetch(
        ~input=`${apiHost}${url}`,
        ~init={method, headers, body: JSON.stringifyAny(b)},
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
    switch Error.message(err) {
    | Some(msg) => Error(msg)
    | _ => Error("Err happen")
    }
  | _ => Error("Unexpected error occurred")
  }
}

let debounce = (delay, callback) => {
  let timeoutID: ref<Null.t<timeoutId>> = ref(Null.null)
  let cancelled = ref(false)

  let clearExistingTimeout = () => {
    switch timeoutID.contents->Null.toOption {
    | Some(timer) => clearTimeout(timer)
    | None => ()
    }
  }

  let cancel = () => {
    clearExistingTimeout()
    cancelled := true
  }
  let wrapper = () => {
    clearExistingTimeout()

    switch cancelled.contents {
    | false => timeoutID := Null.make(setTimeout(() => {
            callback()
          }, delay))
    | _ => ()
    }
  }

  (wrapper, cancel)
}
