/**
 * @description
 * Chrome extensions don't support modules in content scripts.
 * Solution: https://stackoverflow.com/questions/48104433
 */
%%raw(`import("./ContentEntry")`)
