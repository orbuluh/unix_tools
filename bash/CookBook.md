# [Accidentally run commands in a loop and can't stop it](https://askubuntu.com/a/1272603)
- `Ctrl+Z` to stop the job, and send it to the background
- `kill %%` to kill the "current" or "last stopped" job

# Recursive find and in-place replace
```bash
find . -type f -name "*.md" -print0 | xargs -0 sed -i '' -e 's/range_sum/range_query/g'
```

# `getopts`
- check [code](demo/getopts_example.sh)
- `:` means "takes an argument", not "mandatory argument".
  - That is, an option character not followed by `:` means a flag-style option (no argument), whereas an option character followed by `:` means an option with an argument.
- The `getopt()` function parses the command-line arguments. Its arguments `argc` and `argv` are the argument count and array as passed to the `main()` function on program invocation.
- If `getopt()` is called repeatedly, it returns successively each of the option characters from each of the option elements.
- The variable `optind` is the index of the next element to be processed in `argv`.
- If `getopt()` finds another option character, it returns that character, updating the external variable `optind` and a static variable `nextchar` so that the next call to `getopt()` can resume the scan with the following option character or argv-element.
-  legitimate option character is any visible one byte ascii(7) character (for which `isgraph`(3) would return nonzero) that is not `'-'`, `':'`, or `';'`