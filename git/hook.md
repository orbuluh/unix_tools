# Source
- [git doc](https://git-scm.com/docs/githooks)
- [redhat doc](https://www.redhat.com/sysadmin/git-hooks)

# Quick fact
- Git hooks are shell scripts found in the hidden `.git/hooks` directory of a Git repository.
  - can be changed via the `core.hooksPath` configuration variable
- These scripts trigger actions in response to specific events, so they can help you automate your development lifecycle
- Hooks that don’t have the executable bit set are ignored.
- It's important to note that Git hooks aren't committed to a Git repository themselves. They're local, untracked files. When you write an important hook that you want to keep around, copy it into a directory managed by Git!

# Built-in scripts for every git repo

```bash
ls -1 .git/hooks/
```

# Mechanics
- Before Git invokes a hook, it changes its working directory to either `$GIT_DIR` in a bare repository or **the root of the working tree** in a non-bare repository.
  - An exception are hooks triggered during a push (`pre-receive`, `update`, `post-receive`, `post-update`, `push-to-checkout`) which are always executed in `$GIT_DIR`.
- Hooks can get their arguments via the environment, command-line arguments, and stdin.

# Supported hooks
| name | invoked by | when | input | exit with non-zero |
| ---  | ---  | --- | --- | --- |
|`applypatch-msg`| `git-am` | The hook is allowed to edit the message file in place, and can be used to normalize the message into some project standard format.|It takes a single parameter, the name of the file that holds the proposed commit log message. | causes `git am` to abort before applying the patch.|
| `pre-applypatch`  | `git-am` | It can be used to inspect the current working tree and refuse to make a commit if it does not pass certain test. | It takes no parameter, and is invoked after the patch is applied, but before a commit is made. | the working tree will not be committed after applying the patch. |
| `post-applypatch`  | `git-am` | This hook is meant primarily for notification, and cannot affect the outcome of `git am`.  | It takes no parameter, and is invoked after the patch is applied and a commit is made. |N/A|
| `pre-commit`  | `git-commit`| ---  | It takes no parameters, and is invoked before obtaining the proposed commit log message and making a commit. | Causes the git commit command to abort before creating a commit. |
| `pre-merge-commit`  | `git-merge`| ---  | It takes no parameters, and is invoked after the merge has been carried out successfully and before obtaining the proposed commit log message to make a commit. | causes the `git merge` command to abort before creating a commit. |
| `prepare-commit-msg`  | `git-commit`| The purpose of the hook is to edit the message file in place. It should not be used as replacement for pre-commit hook.  | It takes one to three parameters. The first is the name of the file that contains the commit log message. The second is the source of the commit message, followed by a commit object name | `git commit` will abort. |
| `commit-msg`  | `git-commit` or `git-merge` | The hook is allowed to edit the message file in place, and can be used to normalize the message into some project standard format. It can also be used to refuse the commit after inspecting the message file. | It takes a single parameter, the name of the file that holds the proposed commit log message.  | causes the command to abort. |
| `post-commit`  | `git-commit`| This hook is meant primarily for notification, and cannot affect the outcome of `git commit` | It takes no parameters, and is invoked after a commit is made. | --- |
| `pre-rebase`  | `git-rebase`| can be used to prevent a branch from getting rebased  | The hook may be called with one or two parameters. The first parameter is the upstream from which the series was forked. The second parameter is the branch being rebased, and is not set when rebasing the current branch. | --- |
| `post-checkout`  | `git-checkout` or `git-switch` | This hook can be used to perform repository validity checks, auto-display differences from the previous HEAD if different, or set working dir metadata properties.  | The hook is given three parameters: the ref of the previous HEAD, the ref of the new HEAD (which may or may not have changed), and a flag indicating whether the checkout was a branch checkout (changing branches, flag=1) or a file checkout (retrieving a file from the index, flag=0) | This hook cannot affect the outcome of git switch or git checkout, other than that the hook’s exit status becomes the exit status of these two commands. |
| `post-merge`  | `git-merge`| This hook can be used in conjunction with a corresponding pre-commit hook to save and restore any form of metadata associated with the working tree  | The hook takes a single parameter, a status flag specifying whether or not the merge being done was a squash merge. This hook cannot affect the outcome of git merge and is not executed, if the merge failed due to conflicts. | --- |
| `pre-push`  | `git-push`| can be used to prevent a push from taking place.  | The hook is called with two parameters which provide the name and location of the destination remote, if a named remote is not being used both values will be the same. | If this hook exits with a non-zero status, git push will abort without pushing anything. Information about why the push is rejected may be sent to the user by writing to standard error. |
| `pre-receive`  | `git-receive-pack`| check docs for details  | --- | --- |
| `update`  | `git-receive-pack`| check docs for details  | --- | --- |
| `proc-receive`  | `git-receive-pack`| check docs for details  | --- | --- |
| `post-receive`  | `git-receive-pack`| check docs for details  | --- | --- |
| `post-update`  | `git-receive-pack`| check docs for details  | --- | --- |
| `reference-transaction`  | any Git command that performs reference updates. | check docs for details  | --- | --- |
| `push-to-checkout`  | `git-receive-pack`| check docs for details  | --- | --- |
| `pre-auto-gc`  | `git gc --auto`| ---  | It takes no parameter | causes the `git gc --auto` to abort. |
| `post-rewrite`  |  commands that rewrite commits | check docs for detail  | --- | --- |
| `sendemail-validate`  | ` git-send-email`| ---  | It takes a single parameter, the name of the file that holds the e-mail to be sent. | causes `git send-email` to abort before sending any e-mails. |
| `fsmonitor-watchman`  | check docs for details | check docs for details  | --- | --- |
| `p4-changelist`  | `git-p4 submit`| check docs for details  | --- | --- |
| `p4-prepare-changelist`  | `git-p4 submit`| check docs for details  | --- | --- |
| `p4-post-changelist`  | `git-p4 submit`| check docs for details  | --- | --- |
| `p4-pre-submit`  | `git-p4 submit`| check docs for details  | --- | --- |
| `p4-changelist`  | `git-p4 submit`| check docs for details  | --- | --- |
| `post-index-change`  | check docs for details| check docs for details  | --- | --- |
