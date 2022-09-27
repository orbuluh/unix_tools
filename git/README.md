# Adding git-hook for `git add`
- [src](https://stackoverflow.com/a/57719088/4924135)
- [git-attribute](attribute.md)
- If you want to make git support pre-add hooks, then you can use `filters`

```
---staging area---
    |         ^
   smudge     |
    |       clean
    v         |
---working directory---
```

- In a gitattributes file, you assign a filter for the paths you want to hit. For example, in `.git/info/attributes`
```bash
*.h filter=add-hook-hack
```
- Then, in one of git's config files, you'll have to define the `filter.add-hook-hack.clean` command. For example, in `.git/config`:
```bash
[filter "add-hook-hack"]
    clean = $(git rev-parse --show-toplevel)/.git/hooks/pre-add-cmds # (and optionally) cat %f, see below
```
- Then put what you want to trigger into
```
touch .git/hooks/pre-add-cmds
# put what you want to run in the file
# and make sure it's executable
chmod +x .git/hooks/pre-add-cmds
```
- Side note, as the `pre-add-cmds` here is invoked from a different script, so `stdout` won't be tied to your terminal. To output something, do something like `echo "Triggering a pre-add hook" > /dev/tty`)
- NOTE: the say you are filtering file `*.h`, the clean command will basically work on every changed .h file, and it's expected to see the content of each file after running the `pre-add-cmds`. If you don't, it would basically stage the .h file while thinking the file's content is empty. So if your `pre-add-cmds` isn't really manipulating the input file, you should do something like:
```bash
[filter "add-hook-hack"]
    clean = $(git rev-parse --show-toplevel)/.git/hooks/pre-add-cmds && cat %f
```