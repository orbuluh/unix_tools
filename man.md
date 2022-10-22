# man page
- [itsfoss.com/linux-man-page-guide](https://itsfoss.com/linux-man-page-guide/)


# About "sections"
- The word, section is being used in two different ways, but the difference isn’t always explained to newcomers.
  - Sections of a single page of the manual (what we call the man page) are blocks of information defined by the headings and
  - Sections of the manual-at-large (the collection of all of the pages) are chapters which happen to be called sections

# Common headings
- Manual pages are split into several headings and they may vary from vendor to vendor, but they will be similar.
- The general breakdown is as follows:
```markdown
NAME
SYNOPSIS
DESCRIPTION
EXAMPLES
DIAGNOSTICS
FILES
LIMITS
PORTABILITY
SEE ALSO
HISTORY WARNING (or Bugs)
NOTES
```
## SYNOPSIS
- Shows how the command is used.
- The synopsis takes the general form of a command line; it shows what you can type and the order of the arguments. 
- Items not in brackets must be used.
- Arguments in square brackets (`[]`) are optional; you can leave these arguments out and the command will still work correctly.

## DESCRIPTION
- Describes the command or utility as to what it does and how you can use it. 
- This section usually starts off with an explanation of the synopsis as well as telling what happens if you omit any of the optional arguments.
- This section may be subdivided for long or complex commands.

## DIAGNOSTICS
- This section lists status or error messages returned by the command or utility.
- Self-explanatory error and status messages aren’t usually shown.
- Messages that may be hard to understand are usually listed.

## FILES
- This section contains a list of supplementary files used by UNIX to run this specific command. Here, supplementary files are files **not** specified on the command line.
- For example, if you were looking at a man page for the `passwd` command, you may find /etc/passwd listed in this section since that is where UNIX stores password information.

## LIMITS
- This section describes any limitations of a utility.
- Operating system and hardware limitations are usually not listed as they are outside of the utility’s control.

## PORTABILITY
- Lists other systems where the utility is available, along with how other versions of the utility may differ.
- SEE ALSO – lists related man pages that contain relevant information.

## HISTORY
Gives a brief history of the command such as when it first appeared.

## WARNING
- If this section is present, it contains important advice for users.

## NOTES
– Not as severe as a warning, but important information.

# The Manual’s Sections
- The entire Linux manual collection of pages are traditionally divided into numbered sections... The number in the parenthesis is the big clue – that number tells you what section that the page you’re reading, came from. (Same keyword might have different pages in different sections)

```markdown
Section 1 : Shell commands and applications
Section 2 : Basic kernel services – system calls and error codes
Section 3 : Library information for programmers
Section 4 : Network services – if TCP/IP or NFS is installed Device drivers and network protocols
Section 5 : Standard file formats – for example: shows what a `tar` archive looks like.
Section 6 : Games
Section 7 : Miscellaneous files and documents
Section 8 : System administration and maintenance commands
Section 9 : Obscure kernel specs and interfaces
```
- Grouping pages into specific (chapters) sections make searching for information easier
- You can tell which page belongs to which section **by the number next to the name.**
  - For example, if you’re looking at a man page for `ls` and the very top of the page says this: `LS(1)`, **you are viewing the ls page in section 1,** which contains the pages about shell commands and applications.
  - If you’re looking at a man page for passwd and the top of the page shows: `PASSWD(1)`, you are reading the page from section 1 that describes how the passwd command changes passwords for user accounts. If you see `PASSWD(5)`, you are reading about the the password file and how it is made up.
  - To limit your search to a specific section, use an argument with the man command, like so: `man 5 passwd`
- How to know passwd are in section 1 and section 5? `whatis passwd` or the equivalent: `man -f passwd`

# `man -k some_key_word`: Search all man Pages Containing a Certain Keyword
```bash
man -k ftp
```
# `whereis`
```bash
whereis cal
cal: /usr/bin/cal /usr/share/man/man1/cal.1
```
- `/usr/bin/cal` is where the `cal` program is and
- `/usr/share/man/man1/cal.1` is where the man page resides
- `whereis` is PATH dependent; it can only tell you where files are if they are in your PATH environment.
