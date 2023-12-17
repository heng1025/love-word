## A Translator Extension for Browser

### env

- node>=18
- pnpm>=8

### dev

1. rename `.example.env` to `.env`
2. `pnpm dev`

### build

- `pnpm build`

### test

- `pnpm run res:dev` and `pnpm test`

### coverage report (v8)

File                  | % Stmts | % Branch | % Funcs | % Lines | Uncovered Line #s
----------------------|---------|----------|---------|---------|--------------------------------
All files             |   76.44 |    85.25 |   75.49 |   76.44 |
 src                  |   86.15 |    86.84 |      88 |   86.15 |
  Background.js       |   91.39 |    85.71 |     100 |   91.39 | 69-78,159-160,162-163,165-166
  Database.js         |   65.38 |       50 |   33.33 |   65.38 | 5-11,16-17
  Functions.js        |   95.16 |     91.3 |     100 |   95.16 | 72-76,103
  TranSource.js       |    91.3 |    78.57 |     100 |    91.3 | 85-89,97-101
  Utils.js            |   51.61 |      100 |      50 |   51.61 | 7-36
 src/components       |   95.06 |    88.99 |    92.3 |   95.06 |
  DictPanel.js        |     100 |      100 |     100 |     100 |
  FavButton.js        |     100 |      100 |     100 |     100 |
  MachineTPanel.js    |   93.81 |    77.27 |     100 |   93.81 | 20,68-69,72-74
  TranslateResult.js  |     100 |      100 |     100 |     100 |
  Widget.js           |   92.35 |    82.05 |   86.66 |   92.35 | 11-12,99-111,117-127
 src/content_scripts  |       0 |        0 |       0 |       0 |
  ContentApp.js       |       0 |        0 |       0 |       0 | 1-157
 src/hooks            |   98.57 |      100 |     100 |   98.57 |
  RecordHook.js       |   97.85 |      100 |     100 |   97.85 | 93-95
  TranslateHook.js    |     100 |      100 |     100 |     100 |
 src/options          |   63.15 |    69.56 |   42.85 |   63.15 |
  Favorite.js         |   95.83 |     37.5 |      50 |   95.83 | 26-27,32
  History.js          |   98.41 |       50 |      50 |   98.41 | 21
  Login.js            |   71.81 |    36.36 |   14.28 |   71.81 | 28-47,61-63,79-81,86-88,95,100
  OptionsApp.js       |    9.46 |      100 |       0 |    9.46 | 15-83,85-235
  RecordAction.js     |   74.22 |       40 |   14.28 |   74.22 | 20-30,56,63-66,71-74,79-82,87
  Shortcut.js         |     100 |      100 |     100 |     100 |
  TranslateService.js |     100 |      100 |     100 |     100 |
 src/popup            |      80 |    77.77 |      50 |      80 |
  PopupApp.js         |      80 |    77.77 |      50 |      80 | 34-40,43-46,49-56,63-64

### note

- [dict service repo](https://github.com/heng1025/en2zh)

### credit

- [ext boilerplate](https://github.com/Jonghakseo/chrome-extension-boilerplate-react-vite)
