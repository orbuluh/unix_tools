# Git cookbooks


## [Break big PR into several smaller one](./break_big_pr.md)

## Break changes in one file into several commits

<details><summary markdown="span">Steps</summary>

- In Git, a **hunk** refers to a section of a file that contains changes between two versions of the file.
- A hunk is essentially a block of text within a file that has been modified, added or deleted.

```bash
# use -p (e.g. abbreviated for patch) to enter the interactive mode for staging
git add -p that_file

# y to stage the hunk
# n to skip the hunk
# s to split the hunk into smaller hunks
# e to edit the hunk manually
# q to quit the interactive mode
```

</summary></details>



## Publish local folder to remote

<details><summary markdown="span">Steps</summary>

```bash
cd <folder_path>/<folder_name>
git remote add origin https://github.com/<username>/<folder_name>.git
git push -u origin main
```

</summary></details>

## [Adding git-hook for `git add`](./adding_hook_for_git_add.md)
