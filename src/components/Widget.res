open Functions

module Loading = {
  let shouldDelay = (spanning, delay) => {
    spanning && delay > 0
  }

  @react.component
  let make = (~loading=true, ~delay=0, ~children=React.null) => {
    let (spinning, setSpinning) = React.Uncurried.useState(_ =>
      loading && !shouldDelay(loading, delay)
    )

    React.useEffect(() => {
      switch loading {
      | true => {
          let (showSpinning, cancel) = debounce(delay, () => {
            setSpinning(_ => true)
          })
          showSpinning()
          Some(() => cancel())
        }
      | _ => {
          setSpinning(_ => false)
          None
        }
      }
    }, (delay, loading))

    let loadingEl =
      <div dataTestId="loading" className="animate-pulse">
        <h3 className="h-4 mb-2 w-2/3 bg-indigo-200  rounded" />
        <p className="h-3 w-full bg-indigo-300 rounded" />
      </div>

    switch spinning {
    | true => loadingEl
    | false => children
    }
  }
}

module Tag = {
  @react.component
  let make = (~className="", ~role="", ~children) => {
    <span role className={`rounded-sm inline-block text-white px-1 ${className}`}> children </span>
  }
}

module Link = {
  @react.component
  let make = (~children, ~href, ~className="") => {
    <a className={`link text-white ${className}`} target="_blank" href> children </a>
  }
}

module En2zh = {
  @react.component
  let make = () => {
    <svg
      className="w-6 fill-white"
      viewBox="0 0 1024 1024"
      version="1.1"
      title="en2zh"
      xmlns="http://www.w3.org/2000/svg">
      <path
        d="M242.59892654 277.36035538h422.93071748v118.76821517h55.03892898V245.49571228c0-12.81827689-10.35600901-23.17428589-23.17428589-23.17428589H210.73428344c-12.81827689 0-23.17428589 10.35600901-23.17428588 23.17428589v533.00857544c0 12.81827689 10.35600901 23.17428589 23.17428588 23.17428589h393.96286012v-55.03892899H242.59892654V277.36035538z"
      />
      <path
        d="M441.24600839 326.60571289h-43.88630389c-2.46226788 0-4.63485718 1.59323215-5.5038929 3.91066074L299.81044482 597.02066135c-0.21725894 0.57935715-0.28967857 1.23113394-0.28967856 1.88291073 0 3.18646431 2.60710716 5.79357148 5.79357147 5.79357148h39.90322352c2.46226788 0 4.63485718-1.59323215 5.5038929-3.91066074L374.40267754 532.27750015h142.08734035L446.82232094 330.51637363c-0.94145537-2.31742859-3.11404467-3.91066074-5.57631255-3.91066074z m8.98003579 165.11678696h-61.91879511L419.30285644 402.06698132 450.22604418 491.72249985zM819.05928803 523.58714294H720.568573v-67.35026836c0-3.18646431-2.60710716-5.79357148-5.79357147-5.79357148h-40.55500031c-3.18646431 0-5.79357148 2.60710716-5.79357147 5.79357148v67.35026836H569.93571472c-9.63181258 0-17.38071443 7.74890185-17.38071442 17.38071443v127.45857237c0 9.63181258 7.74890185 17.38071443 17.38071442 17.38071443h98.49071503v110.07785797c0 3.18646431 2.60710716 5.79357148 5.79357147 5.79357147h40.55500031c3.18646431 0 5.79357148-2.60710716 5.79357147-5.79357148V685.80714417h98.49071503c9.63181258 0 17.38071443-7.74890185 17.38071441-17.38071443V540.96785737c0-9.63181258-7.74890185-17.38071443-17.38071442-17.38071443zM668.42642975 633.66500092h-63.7292862v-57.93571473h63.7292862v57.93571472z m115.87142944-1e-8h-63.72928619v-57.93571472h63.7292862v57.93571472z"
      />
    </svg>
  }
}

module Zh2en = {
  @react.component
  let make = () => {
    <svg
      className="w-6 fill-white"
      viewBox="0 0 1024 1024"
      version="1.1"
      title="zh2en"
      xmlns="http://www.w3.org/2000/svg">
      <path
        d="M295.7066648 604.69714356v61.79809546a61.79809547 61.79809547 0 0 0 57.163239 61.64360046L357.50476098 728.2933352h92.69714355v61.79809546H357.50476098a123.59619164 123.59619164 0 0 1-123.59619165-123.59619164v-61.79809546h61.79809547z m401.68762231-154.49523903l135.95581031 339.88952614h-66.58744764l-37.10975671-92.69714356h-126.37710595l-37.04795814 92.69714356h-66.55654908L635.59619164 450.20190453h61.79809547z m-30.89904809 89.14375282L627.96412659 635.59619164h77.00042701L666.49523902 539.34565735zM388.40380836 203.00952125v61.79809617h123.59619164v216.29333449H388.40380836v92.69714356H326.60571289v-92.69714356H203.00952125V264.80761742h123.59619164V203.00952125h61.79809547z m278.09143066 30.89904809a123.59619164 123.59619164 0 0 1 123.59619164 123.59619164v61.79809547h-61.79809546V357.50476098a61.79809547 61.79809547 0 0 0-61.79809618-61.79809618h-92.69714355V233.90856933h92.69714355zM326.60571289 326.60571289H264.80761742v92.69714356h61.79809547V326.60571289z m123.59619164 0H388.40380836v92.69714356h61.79809617V326.60571289z"
      />
    </svg>
  }
}

// [icon source]: https://heroicons.com/
module Speaker = {
  @react.component
  let make = (~isPlay, ~onClick, ~className="") => {
    // https://tailwindcss.com/docs/content-configuration#class-detection-in-depth
    let animate200ms = isPlay ? "animate-fadeInOut-200ms" : ""
    let klass = `btn btn-xs btn-circle btn-ghost min-h-0 ${className}`
    <button className=klass onClick>
      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 24 24"
        fill="currentColor"
        className="w-4 h-4">
        <path
          d="M13.5 4.06c0-1.336-1.616-2.005-2.56-1.06l-4.5 4.5H4.508c-1.141 0-2.318.664-2.66 1.905A9.76 9.76 0 001.5 12c0 .898.121 1.768.35 2.595.341 1.24 1.518 1.905 2.659 1.905h1.93l4.5 4.5c.945.945 2.561.276 2.561-1.06V4.06zM18.584 5.106a.75.75 0 011.06 0c3.808 3.807 3.808 9.98 0 13.788a.75.75 0 11-1.06-1.06 8.25 8.25 0 000-11.668.75.75 0 010-1.06z"
        />
        <path
          dataTestId="play"
          className=animate200ms
          d="M15.932 7.757a.75.75 0 011.061 0 6 6 0 010 8.486.75.75 0 01-1.06-1.061 4.5 4.5 0 000-6.364.75.75 0 010-1.06z"
        />
      </svg>
    </button>
  }
}

module Alert = {
  @react.component
  let make = () => {
    <svg
      xmlns="http://www.w3.org/2000/svg"
      title="alert"
      fill="none"
      viewBox="0 0 24 24"
      strokeWidth="1.5"
      stroke="currentColor"
      className="w-6 h-6">
      <path
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M12 9v3.75m0-10.036A11.959 11.959 0 013.598 6 11.99 11.99 0 003 9.75c0 5.592 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.57-.598-3.75h-.152c-3.196 0-6.1-1.249-8.25-3.286zm0 13.036h.008v.008H12v-.008z"
      />
    </svg>
  }
}

module Jump = {
  @react.component
  let make = () => {
    <svg
      xmlns="http://www.w3.org/2000/svg"
      title="jump"
      fill="none"
      viewBox="0 0 24 24"
      strokeWidth="1.5"
      stroke="currentColor"
      className="w-h h-4">
      <path
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5m-13.5-9L12 3m0 0l4.5 4.5M12 3v13.5"
      />
    </svg>
  }
}

module Settting = {
  @react.component
  let make = () => {
    <svg
      xmlns="http://www.w3.org/2000/svg"
      title="setting"
      fill="none"
      viewBox="0 0 24 24"
      strokeWidth="1.5"
      stroke="currentColor"
      className="w-4 h-4">
      <path
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M9.594 3.94c.09-.542.56-.94 1.11-.94h2.593c.55 0 1.02.398 1.11.94l.213 1.281c.063.374.313.686.645.87.074.04.147.083.22.127.324.196.72.257 1.075.124l1.217-.456a1.125 1.125 0 011.37.49l1.296 2.247a1.125 1.125 0 01-.26 1.431l-1.003.827c-.293.24-.438.613-.431.992a6.759 6.759 0 010 .255c-.007.378.138.75.43.99l1.005.828c.424.35.534.954.26 1.43l-1.298 2.247a1.125 1.125 0 01-1.369.491l-1.217-.456c-.355-.133-.75-.072-1.076.124a6.57 6.57 0 01-.22.128c-.331.183-.581.495-.644.869l-.213 1.28c-.09.543-.56.941-1.11.941h-2.594c-.55 0-1.02-.398-1.11-.94l-.213-1.281c-.062-.374-.312-.686-.644-.87a6.52 6.52 0 01-.22-.127c-.325-.196-.72-.257-1.076-.124l-1.217.456a1.125 1.125 0 01-1.369-.49l-1.297-2.247a1.125 1.125 0 01.26-1.431l1.004-.827c.292-.24.437-.613.43-.992a6.932 6.932 0 010-.255c.007-.378-.138-.75-.43-.99l-1.004-.828a1.125 1.125 0 01-.26-1.43l1.297-2.247a1.125 1.125 0 011.37-.491l1.216.456c.356.133.751.072 1.076-.124.072-.044.146-.087.22-.128.332-.183.582-.495.644-.869l.214-1.281z"
      />
      <path strokeLinecap="round" strokeLinejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
    </svg>
  }
}

module Star = {
  @react.component
  let make = () => {
    <svg
      xmlns="http://www.w3.org/2000/svg"
      title="star"
      fill="none"
      viewBox="0 0 24 24"
      strokeWidth="1.5"
      stroke="currentColor"
      className="w-4 h-4">
      <path
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M11.48 3.499a.562.562 0 011.04 0l2.125 5.111a.563.563 0 00.475.345l5.518.442c.499.04.701.663.321.988l-4.204 3.602a.563.563 0 00-.182.557l1.285 5.385a.562.562 0 01-.84.61l-4.725-2.885a.563.563 0 00-.586 0L6.982 20.54a.562.562 0 01-.84-.61l1.285-5.386a.562.562 0 00-.182-.557l-4.204-3.602a.563.563 0 01.321-.988l5.518-.442a.563.563 0 00.475-.345L11.48 3.5z"
      />
    </svg>
  }
}

module StarFill = {
  @react.component
  let make = () => {
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      title="star-fill"
      fill="currentColor"
      className="w-4 h-4">
      <path
        fillRule="evenodd"
        d="M10.788 3.21c.448-1.077 1.976-1.077 2.424 0l2.082 5.007 5.404.433c1.164.093 1.636 1.545.749 2.305l-4.117 3.527 1.257 5.273c.271 1.136-.964 2.033-1.96 1.425L12 18.354 7.373 21.18c-.996.608-2.231-.29-1.96-1.425l1.257-5.273-4.117-3.527c-.887-.76-.415-2.212.749-2.305l5.404-.433 2.082-5.006z"
        clipRule="evenodd"
      />
    </svg>
  }
}

module Eye = {
  @react.component
  let make = (~className="") => {
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      title="eye"
      fill="currentColor"
      className>
      <path d="M12 15a3 3 0 100-6 3 3 0 000 6z" />
      <path
        fillRule="evenodd"
        d="M1.323 11.447C2.811 6.976 7.028 3.75 12.001 3.75c4.97 0 9.185 3.223 10.675 7.69.12.362.12.752 0 1.113-1.487 4.471-5.705 7.697-10.677 7.697-4.97 0-9.186-3.223-10.675-7.69a1.762 1.762 0 010-1.113zM17.25 12a5.25 5.25 0 11-10.5 0 5.25 5.25 0 0110.5 0z"
        clipRule="evenodd"
      />
    </svg>
  }
}

module EyeSlash = {
  @react.component
  let make = (~className="") => {
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      title="eyeSlash"
      fill="currentColor"
      className>
      <path
        d="M3.53 2.47a.75.75 0 00-1.06 1.06l18 18a.75.75 0 101.06-1.06l-18-18zM22.676 12.553a11.249 11.249 0 01-2.631 4.31l-3.099-3.099a5.25 5.25 0 00-6.71-6.71L7.759 4.577a11.217 11.217 0 014.242-.827c4.97 0 9.185 3.223 10.675 7.69.12.362.12.752 0 1.113z"
      />
      <path
        d="M15.75 12c0 .18-.013.357-.037.53l-4.244-4.243A3.75 3.75 0 0115.75 12zM12.53 15.713l-4.243-4.244a3.75 3.75 0 004.243 4.243z"
      />
      <path
        d="M6.75 12c0-.619.107-1.213.304-1.764l-3.1-3.1a11.25 11.25 0 00-2.63 4.31c-.12.362-.12.752 0 1.114 1.489 4.467 5.704 7.69 10.675 7.69 1.5 0 2.933-.294 4.242-.827l-2.477-2.477A5.25 5.25 0 016.75 12z"
      />
    </svg>
  }
}

module Search = {
  @react.component
  let make = () => {
    <svg
      xmlns="http://www.w3.org/2000/svg"
      title="search"
      fill="none"
      viewBox="0 0 24 24"
      strokeWidth="2"
      stroke="currentColor">
      <path
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z"
      />
    </svg>
  }
}
