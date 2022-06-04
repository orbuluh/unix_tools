- Reading notes from [Basic grammar rules](https://wiki.bash-hackers.org/syntax/basicgrammar)

# Simple Commands
- Every complex Bash operation can be split into simple commands.
- A simple command is **a sequence of optional variable assignments** followed by **blank-separated words** and **redirections**,
and **terminated by a control operator**.
    - The first word specifies the command to be executed, and is passed as argument zero.
    - The remaining words are passed as arguments to the invoked command.
- Every command has an exit code. It's a type of return status.
  - The shell can catch it and act on it.
  - Exit code range is from 0 to 255, where 0 means success, and the rest mean either something failed, or there is an issue to report back to the calling program.
- The simple command construct is the base for all higher constructs. Everything you execute, from pipelines to functions, finally ends up in (many) simple commands.
- That's why Bash only has [one method to expand and execute a simple command](CommandExpansion.md).

# Pipelines (not "pipe" `|`)
- A pipeline is a sequence of one or more commands separated by one of the control operators `|` or `|&`.
  - Don't get confused about the name "pipeline." It's a grammatic name for a construct.
  - Such a pipeline isn't necessarily a pair of commands where stdout/stdin is connected via a real pipe `|`.
- The format for a pipeline is
```bash
[time [-p]] [!] command1 [ | or |& command2 ] ...
```
- The last command in the pipeline will set the exit code for the pipeline.
  - This exit code can be "inverted" by prefixing an exclamation mark to the pipeline: An unsuccessful pipeline will exit "successful" and vice versa.
```bash
if ! grep '^root:' /etc/passwd; then
  echo "No root user defined... eh?"
fi
```
- Yes, this is also a pipeline (although there is no pipe!), because the **exclamation mark to invert the exit code can only be used in a pipeline.**
- **If grep's exit code is 1 (FALSE) (the text was not found), the leading ! will "invert" the exit code, and the shell sees (and acts on) exit code 0 (TRUE) and the then part of the if stanza is executed.**
  - One could say we checked for "not grep "^root" /etc/passwd".
- The set option `pipefail` determines the behavior of how bash reports the exit code of a pipeline.
  - If it's set, then the exit code (`$?`) is the last command that exits with non zero status, if none fail, it's zero.
  - If it's not set, then `$?` always holds the exit code of the last command (as explained above).

- The shell option `lastpipe` will execute the last element in a pipeline construct in the **current shell environment, i.e. not a subshell.**
- There's also an array `PIPESTATUS[]` that is set after a foreground pipeline is executed.
- Each element of `PIPESTATUS[]` reports the exit code of the respective command in the pipeline.
  - Note... 
  - (1) it's only for foreground pipe and
  - (2) for higher level structure that is built up from a pipeline.
- Like list, `PIPESTATUS[]` holds the exit status of the last pipeline command executed.
- Another thing you can do with pipelines is log their execution time. Note that **`time` is not a command, it is part of the pipeline syntax**:
```bash
# time updatedb
real    3m21.288s
user    0m3.114s
sys     0m4.744s
```

# Lists
- A list is a sequence of one or more pipelines separated by one of the operators `;`, `&`, `&&`, or `||`, and optionally terminated by one of `;` , `&`, or `<newline>`.
⇒ It's a group of pipelines separated or terminated by tokens that all have different meanings for Bash.
- **Your whole Bash script technically is one big single list!**

- `<PIPELINE1> <newline> <PIPELINE2>`: Newlines completely separate pipelines. **The next pipeline is executed without any checks.**
- `<PIPELINE1> ; <PIPELINE2>`: The semicolon does what <newline> does: It separates the pipelines
- `<PIPELINE> & <PIPELINE>`: The pipeline in front of the `&` is executed asynchronously ("in the background"). If a pipeline follows this, it is executed immediately after the async pipeline **starts**
- `<PIPELINE1> && <PIPELINE2>`: `<PIPELINE1>` is executed and only if its exit code was 0 (TRUE), then `<PIPELINE2>` is executed (AND-List)
- `<PIPELINE1> || <PIPELINE2>`: `<PIPELINE1>` is executed and only if its exit code was not 0 (FALSE), then <PIPELINE2> is executed (OR-List)

# Compound Commands
- There are two forms of compound commands:
  - form a new syntax element using a list as a "body"
  - completly independant syntax elements
- Essentially, everything else that's not described in this article.
- Compound commands have the following characteristics:
  - they begin and end with a specific keyword or operator (e.g. for … done)
  - they can be redirected as a whole
- See the below short overview (no details - just an overview):

## `( <LIST> )`: Execute `<LIST>` in an extra subshell
- e.g. Grouping commands in a subshell.
- The list `<LIST>` is executed in a separate shell - a subprocess.
- No changes to the environment (variables etc…) are reflected in the "main shell".
```bash
echo "$PWD"
( cd /usr; echo "$PWD" )
echo "$PWD" # Still in the original directory.
```

## `{ <LIST> ; }`: Execute <LIST> as separate group (but not in a subshell). A.k.a "group command"
```bash
# equivalent to ..
{
<LIST>
}
```
- Grouping commands: The list `<LIST>` is simply executed in the current shell environment.
- The list must be terminated with a newline or semicolon.
- For parsing reasons, the curly braces **must** be separated from `<LIST>` by **a semicolon and blanks if they're in the same line**!
- The return status is the exit status (exit code) of the list.
- The input and output filedescriptors are cumulative:
```bash
{
  echo "PASSWD follows"
  cat /etc/passwd
  echo
  echo "GROUPS follows"
  cat /etc/group
} >output.txt
```
- This compound command also usually is the body of a function definition, though not the only compound command that's valid there
```bash
print_help() {
  echo "Options:"
  echo "-h           This help text"
}
```
- A try-catch block using grouping command:
```bash
try_catch() {
    { # Try-block:
        eval "$@"
    } ||
    { # Catch-block:
        echo "An error occurred"
        return -1
    }
}
```

## `(( <EXPRESSION> ))`: Evaluate the arithmetic expression `<EXPRESSION>`. A.k.a. "Arithmetic evaluation command"
- If the expression evaluates to 0 then the exit code of the expression is set to 1 (FALSE).
- If the expression evaluates to something else than 0, then the exit code of the expression is set to 0 (TRUE).
- For this return code mapping, please see [Arithmetic expressions](ArithmeticExpressions.md)
- The functionality basically is equivalent to what the ''let'' builtin command does.
- The arithmetic evaluation compound command should be preferred.

## `[[ <EXPRESSION> ]]`: 	Evaluate the conditional expression <EXPRESSION> A.k.a. "the new test command"
- [Conditional expression](ConditionalExpression.md)

