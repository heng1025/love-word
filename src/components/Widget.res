module Loading = {
  @react.component
  let make = () => {
    <div> {React.string("loading...")} </div>
  }
}

module Tag = {
  @react.component
  let make = (~className="", ~children) => {
    <span className={`rounded-sm inline-block text-white px-1 ${className}`}> children </span>
  }
}

module Alert = {
  @react.component
  let make = () => {
    <svg
      xmlns="http://www.w3.org/2000/svg"
      className="stroke-current flex-shrink-0 h-6 w-6"
      fill="none"
      viewBox="0 0 24 24">
      <path
        strokeLinecap="round"
        strokeLinejoin="round"
        strokeWidth="2"
        d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
      />
    </svg>
  }
}
module Speaker = {
  @react.component
  let make = (~isPlay, ~onClick) => {
    // https://tailwindcss.com/docs/content-configuration#class-detection-in-depth
    let animate200ms = isPlay ? "animate-fadeInOut-200ms" : ""
    let animate400ms = isPlay ? "animate-fadeInOut-400ms" : ""
    <button
      className="btn btn-xs w-5 h-5 min-h-0 btn-circle btn-ghost ml-[2px] align-middle inline-flex"
      onClick>
      <svg
        className="fill-warning"
        viewBox="0 0 1024 1024"
        version="1.1"
        xmlns="http://www.w3.org/2000/svg">
        <path
          d="M610.87695313 256.56787084c0-35.56274388-41.98974585-54.38232422-68.55468776-30.7836909L394.23754883 357.38940455a24.71923828 24.71923828 0 0 1-16.41357422 6.26220652H256.56787084A74.15771484 74.15771484 0 0 0 182.410156 437.80932592v148.21655273a74.15771484 74.15771484 0 0 0 74.15771484 74.15771484h121.28906301a24.71923828 24.71923828 0 0 1 16.41357422 6.26220729l148.01879882 131.63818385c26.56494115 23.59863255 68.58764623 4.74609375 68.58764624-30.78369167V256.56787084zM427.13061498 394.33642578L561.43847655 274.92602563v474.01611329l-134.30786157-119.44335937a74.15771484 74.15771484 0 0 0-49.27368113-18.75366263H256.56787084a24.71923828 24.71923828 0 0 1-24.71923827-24.71923827V437.84228516a24.71923828 24.71923828 0 0 1 24.71923827-24.71923829h121.28906301a74.15771484 74.15771484 0 0 0 49.27368113-18.75366185z"
        />
        <path
          className=animate200ms
          d="M681.50805689 392.35888672a24.71923828 24.71923828 0 0 1 33.51928711 9.95361303c17.66601537 32.62939453 27.68554688 70.03784205 27.68554688 109.68750025a229.8229983 229.8229983 0 0 1-27.68554688 109.68750025 24.71923828 24.71923828 0 0 1-43.50585937-23.53271484c13.84277344-25.60913086 21.75292969-54.90966822 21.7529297-86.15478541s-7.91015625-60.54565455-21.7529297-86.15478541a24.71923828 24.71923828 0 0 1 9.98657226-33.51928711z"
        />
        <path
          className=animate400ms
          d="M742.4492185 310.85131811a24.71923828 24.71923828 0 0 1 34.57397511 5.1745608A328.23852514 328.23852514 0 0 1 841.589844 512a328.27148438 328.27148438 0 0 1-64.59960962 195.97412109 24.71923828 24.71923828 0 0 1-39.71557592-29.39941431A278.80004858 278.80004858 0 0 0 792.15136743 512a278.80004858 278.80004858 0 0 0-54.87670897-166.57470678 24.71923828 24.71923828 0 0 1 5.17456004-34.57397511z"
        />
      </svg>
    </button>
  }
}

module Jump = {
  @react.component
  let make = () => {
    <svg viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg">
      <path
        d="M646.43969701 681.06311061L604.18627955 639.12280248 696.05944825 544.20092748 404.47131347 544.20092748 404.47131347 479.43652318 703.90368678 479.43652318 604.18627955 384.43225123 646.43969701 342.49194311 816.93652344 511.76928686 646.43969701 681.06311061ZM266.81811549 511.76928686C266.81811549 642.61645508 374.03369115 749.07397436 505.82019042 749.07397436L505.82019042 808.40014623C341.07470728 808.40014623 207.06347656 675.32824733 207.06347656 511.76928686 207.06347656 348.22680639 341.07470728 215.13842748 505.82019042 215.13842748L505.82019042 274.46459936C374.03369115 274.46459936 266.81811549 380.92211939 266.81811549 511.76928686Z"
      />
    </svg>
  }
}

module Star = {
  @react.component
  let make = () => {
    <svg viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg">
      <path
        d="M511.59696106 248.27742914c3.21503933 0 6.47308027 2.16696835 7.92587604 5.27745272l62.99806888 134.7761533 11.92338391 25.50867352 27.83247391 4.26648285 145.02414221 22.22955285c3.31706387 0.50590722 5.89297329 2.77911557 7.07679575 6.24036265 1.23441284 3.78840042 0.43339334 7.50934616-2.22936384 10.24461721L665.51579135 566.53002826l-18.48078232 19.01367142 4.25467777 26.17141196 24.73294922 152.1549017c0.5834795 3.57844922-1.0312067 7.63582297-3.84742255 9.70076678-1.55566406 1.0666203-3.16191851 1.58517554-4.90392526 1.58517554-1.36594885 0-2.79429319-0.37268454-4.02533267-1.05060059L537.16465671 704.15106512l-25.56769565-14.18647549-25.56769648 14.1864755-125.94385985 69.88177689c-1.48652353 0.80692163-3.05567853 0.97640085-4.11471086 0.97640002-1.8372854 0-3.61976495-0.50927976-4.9005519-1.39883286-2.89800357-2.09867075-4.5034151-6.06582504-3.90813217-9.67800037l0.00927548-0.0581792 0.00927466-0.05818002 24.70259564-152.11021261 4.24877564-26.16045063-18.46813514-19.00945513-106.59881964-109.71773658-0.02866772-0.02951147-0.02866855-0.02951147c-2.59783209-2.66528678-3.42077426-6.4511576-2.20575449-10.13416013 1.17792032-3.49666067 3.76141855-5.79432128 7.10715015-6.30528772l145.0055929-22.21437607 27.84006188-4.26479535 11.92338474-25.51626315 62.96181152-134.73568049c1.46375794-3.12734866 4.73613272-5.31118048 7.95707419-5.31117965m0-52.69864581c-23.67560439 0-45.53500232 13.99423069-55.68181045 35.66054086L392.93478894 366.01547748 247.92919604 388.22901062c-22.86362356 3.49581692-41.67746136 19.47826208-49.11176486 41.70191363-7.47308963 22.42517102-1.92919236 46.80229916 14.45039045 63.60852942l106.59797671 109.72026618-24.70259563 152.10936968c-3.86765936 23.48335959 6.11304291 47.51141253 25.44796553 61.24763041 10.38627082 7.3407107 22.8417009 11.09201083 35.35868272 11.09201084 10.1636716 0 20.36865893-2.47472864 29.53063449-7.51018909l126.09647561-69.96693796 126.13779053 69.98633103a61.16246933 61.16246933 0 0 0 29.53738037 7.63666589c12.6552637 0 24.85942686-3.89042496 35.33338752-11.25727378 19.27758636-13.69743173 29.25913073-37.72464175 25.4294154-61.20884426l-24.72873459-152.12960651 106.63339032-109.71014776c16.35934598-16.80623025 21.8939686-41.17408374 14.43099737-63.64900224-7.44442108-22.21437607-26.2734365-38.17658524-49.12188327-41.66144082L630.26166196 366.01547748l-62.99806806-134.77615329c-10.11898333-21.65703552-31.97163537-35.66054087-55.66663284-35.66054086z"
      />
    </svg>
  }
}
module StarFill = {
  @react.component
  let make = () => {
    <svg viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg">
      <path
        d="M695.25195338 831.38641493a32.95898463 32.95898463 0 0 1-15.16113307-3.62548803L512 739.76043862l-168.09082031 88.00048828a32.95898463 32.95898463 0 0 1-47.7905276-34.93652369l32.95898462-185.55908178-135.79101587-131.83593776a32.95898463 32.95898463 0 0 1-8.23974559-32.95898462 32.95898463 32.95898463 0 0 1 26.69677735-22.41210912l187.86621093-27.35595678 82.72705053-169.07958984a32.95898463 32.95898463 0 0 1 59.32617188 0l83.71582005 168.74999974 187.86621094 27.35595678a32.95898463 32.95898463 0 0 1 26.69677735 22.41210989 32.95898463 32.95898463 0 0 1-8.23974559 32.95898386l-135.79101588 131.83593775 32.95898463 185.55908178a32.95898463 32.95898463 0 0 1-13.18359401 32.95898463 32.95898463 32.95898463 0 0 1-20.43457005 5.93261718z"
      />
    </svg>
  }
}
module En2zh = {
  @react.component
  let make = () => {
    <svg
      className="w-6 fill-white"
      viewBox="0 0 1024 1024"
      version="1.1"
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
      xmlns="http://www.w3.org/2000/svg">
      <path
        d="M295.7066648 604.69714356v61.79809546a61.79809547 61.79809547 0 0 0 57.163239 61.64360046L357.50476098 728.2933352h92.69714355v61.79809546H357.50476098a123.59619164 123.59619164 0 0 1-123.59619165-123.59619164v-61.79809546h61.79809547z m401.68762231-154.49523903l135.95581031 339.88952614h-66.58744764l-37.10975671-92.69714356h-126.37710595l-37.04795814 92.69714356h-66.55654908L635.59619164 450.20190453h61.79809547z m-30.89904809 89.14375282L627.96412659 635.59619164h77.00042701L666.49523902 539.34565735zM388.40380836 203.00952125v61.79809617h123.59619164v216.29333449H388.40380836v92.69714356H326.60571289v-92.69714356H203.00952125V264.80761742h123.59619164V203.00952125h61.79809547z m278.09143066 30.89904809a123.59619164 123.59619164 0 0 1 123.59619164 123.59619164v61.79809547h-61.79809546V357.50476098a61.79809547 61.79809547 0 0 0-61.79809618-61.79809618h-92.69714355V233.90856933h92.69714355zM326.60571289 326.60571289H264.80761742v92.69714356h61.79809547V326.60571289z m123.59619164 0H388.40380836v92.69714356h61.79809617V326.60571289z"
      />
    </svg>
  }
}
