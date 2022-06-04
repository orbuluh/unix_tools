- Reading notes from [Simple command expansion](https://wiki.bash-hackers.org/syntax/grammar/parser_exec)
# Command expansion
- The expansion of a simple command is done in four steps (interpreting the simple command from left to right):
  1. The words the parser has marked as variable assignments and redirections are saved for later processing.
     - a. variable assignments precede the command name and have the form WORD=WORD
     - b. **redirections can appear anywhere in the simple command**
  2. The rest of the words are expanded.
     - If any words remain after expansion, the first word is taken to be the name of the command and the remaining words are the arguments.
  3. Redirections are performed.
  4. The text after the = in each variable assignment undergoes
     - tilde expansion
     - parameter expansion
     - command substitution
     - arithmetic expansion, and
     - quote removal
     - ... before being assigned to the variable.

- If **no command name** results after expansion:
  - The variable assignments affect the **current shell** environment.
    - This is what happens when you enter only a variable assignment at the command prompt.
    - Assignment to readonly variables causes an error and the command exits non-zero.
  - Redirections are performed, but do not affect the current shell environment.
    - that means, a > FILE without any command will be performed: the FILE will be created!
  - The command exits
    - with an exit code indicating the redirection error, if any
    - with the exit code of the last command-substitution parsed, if any
    - with exit code 0 (zero) if no redirection error happened and no command substitution was done
- Otherwise, if a command name results:
  - The variables saved and parsed are added to the environment of the executed command (and thus do not affect the current environment)
  - Assignment to readonly variables causes an error and the command exits with a non-zero error code.
  - Assignment errors in non-POSIX modes cause the enclosing commands (e.g. loops) to completely terminate.
  - Assignment errors in (non-interactive) POSIX mode cause the entire script to terminate
```bash
# This one terminates only the enclosing compound command (the { …; }):
# The following is an assignment error!
# The "echo TEST" won't be executed, since the { ...; } is terminated
{ foo=$((8#9)); echo TEST; }
```

# Command execution
- If a parsed simple command contains no slashes, the shell attempts to locate and execute it:
  - shell functions
  - shell builtin commands
  - check own hash table
  - search along PATH