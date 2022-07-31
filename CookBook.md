# [Accidentally run commands in a loop and can't stop it](https://askubuntu.com/a/1272603)
- `Ctrl+Z` to stop the job, and send it to the background
- `kill %%` to kill the "current" or "last stopped" job

# Recursive find and in-place replace
```bash
find . -type f -name "*.md" -print0 | xargs -0 sed -i '' -e 's/range_sum/range_query/g'
```