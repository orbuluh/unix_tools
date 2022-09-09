- Reading notes from [Bash's behaviour](https://wiki.bash-hackers.org/scripting/bashbehaviour)
# Login shell
- As a "login shell", Bash reads and sets (executes) the user's profile from `/etc/profile` and one of file (in that order, using the first one that's readable!).
  - `~/.bash_profile`, `~/.bash_login`, or `~/.profile`
  - `--noprofile` disables reading of all profile files
- When a login shell exits, Bash reads and executes commands from the file `~/.bash_logout`, if it exists.

# Interactive shell
- When Bash starts as an interactive non-login shell, it reads and executes commands from `~/.bashrc` (**not inherited from the parent shell**).
- The classic way to have a system-wide rc file is to source `/etc/bashrc` from every user's `~/.bashrc`.
  - `--norc` disables reading of the startup files (e.g. `/etc/bash.bashrc` if supported) and `~/.bashrc`
  - `--rcfile` defines another startup file (instead of `/etc/bash.bashrc` and `~/.bashrc`)

