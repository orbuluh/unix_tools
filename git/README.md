# Adding git-hook for `git add`
- [src](https://stackoverflow.com/a/57719088/4924135)
- [git-attribute](attribute.md)
- If you want to make git support pre-add hooks, then you can use `filters`
- In a gitattributes file, you assign a filter for the paths you want to hit. For example, in `.git/info/attributes`
```bash
*.h filter=add-hook-hack
```
- Then, in one of git's config files, you'll have to define the `filter.add-hook-hack.clean` command. For example, in `.git/config`:
```bash
[filter "add-hook-hack"]
    clean = $(git rev-parse --show-toplevel)/.git/hooks/pre-add-cmds
```
- Then put what you want to trigger into
```
touch .git/hooks/pre-add-cmds
# put what you want to run in the file
# and make sure it's executable
chmod +x .git/hooks/pre-add-cmds
```
- Side note, as the `pre-add-cmds` here is invoked from a different script, so `stdout` won't be tied to your terminal. To output something, do something like `echo "Triggering a pre-add hook" > /dev/tty`)
