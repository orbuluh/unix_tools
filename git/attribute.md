# gitattributes
- [git doc](https://git-scm.com/docs/gitattributes)

# Quick intro
- `gitattributes` file is a simple text file that gives **attributes to path names. Certain operations by Git can be influenced by assigning particular attributes to a path.**
- When the pattern matches the path in question, the attributes listed on the line are given to the path.
- When more than one pattern matches the path, a later line overrides an earlier line. This overriding is done per attribute.
- The rules by which the pattern matches paths are the same as in `.gitignore`
- When deciding what attributes are assigned to a path, Git consults following files in orders:
  - `$GIT_DIR/info/attributes`
  - `.gitattributes` file in the same directory as the path in question, and
  - its parent directories up to the toplevel of the work tree (the further the directory that contains `.gitattributes`
  - Finally global and system-wide files are considered.

# filter
- A filter attribute can be set to a string value that names a filter driver specified in the configuration.
- A filter driver consists of a `clean` command and a `smudge` command, **either of which can be left unspecified.**
- Upon checkout, when the `smudge` command is specified, the command is **fed the blob object from its standard input, and its standard output is used to update the worktree file.**
- Similarly, the `clean` command is used to **convert the contents of worktree file upon checkin**.
- By default these commands process only a single blob and terminate.
- If a long running process filter is used in place of `clean` and/or `smudge` filters, then Git can process all blobs **with a single filter command invocation for the entire life of a single Git command**, for example `git add --all`.
- If a long running process filter is configured then it always takes precedence over a configured single blob filter.


- One use of the content filtering is to massage the content into a shape that is more convenient for the platform, filesystem, and the user to use.
  - For this mode of operation, the key phrase here is **"more convenient" and not "turning something unusable into usable"**. In other words, the intent is that **if someone unsets the filter driver definition, or does not have the appropriate filter program, the project should still be usable.**

- Another use of the content filtering is to **store the content that cannot be directly used in the repository** (e.g. a UUID that refers to the true content stored outside Git, or an encrypted content) and turn it into a usable form upon checkout (e.g. download the external content, or decrypt the encrypted content).

- These two filters behave differently, and by default, **a filter is taken as the former, massaging the contents into more convenient shape.**

- A missing filter driver definition in the config, or a filter driver that exits with a non-zero status, is not an error but makes the filter a no-op passthru.

- You can declare that a filter turns a content that by itself is unusable into a usable content by setting the `filter.<driver>.required` configuration variable to true.
- Note: Whenever the clean filter is changed, the repo should be renormalized: `$ git add --renormalize`.

# Example
- in `.gitattributes`, you would assign the filter attribute for paths.
```bash
*.c	filter=indent
```
- Then you would define a `"filter.indent.clean"` and `"filter.indent.smudge"` configuration in your `.git/config` to specify a pair of commands to modify the contents of C programs when the source files are **checked in ("clean" (還沒被弄髒, before checked in) is run)** and **checked out ("smudge" (被弄髒)** is run, and no change is made because the command is `cat`).
```bash
[filter "indent"]
  #indent is a gnu format command
	clean = indent
	smudge = cat
```

# `clean` and `smudge`
- For best results, **`clean` should not alter its output further** if it is run twice ("clean→clean" should be equivalent to "clean"), and **multiple `smudge` commands should not alter clean's output** ("smudge→smudge→clean" should be equivalent to "clean").
- The "indent" filter is well-behaved in this regard: it will not modify input that is already correctly indented. In this case, the lack of a `smudge` filter means that `the` clean filter must accept its own output without modifying it.
- If a filter must succeed in order to make the stored contents usable, you can declare that the filter is required, in the configuration:
```bash
[filter "crypt"]
	clean = openssl enc ...
	smudge = openssl enc -d ...
	required
```

# About `%f`
- Sequence `%f` on the filter command line is replaced with **the name of the file the filter is working on.** A filter might use this in keyword substitution. For example:
```cpp
[filter "p4"]
	clean = git-p4-filter --clean %f
	smudge = git-p4-filter --smudge %f
```
- Note that `%f` is **the name of the path that is being worked on**. Depending on the version that is being filtered, the corresponding file on disk may not exist, or may have different contents. So, `smudge` and `clean` commands should not try to access the file on disk, but **only act as filters on the content provided to them on standard input.**

# Long Running Filter Process
- If the filter command (a string value) is defined via `filter.<driver>.process` then Git can process all blobs with a single filter invocation for the entire life of a single Git command. This is achieved by using the long-running process protocol.
- When Git encounters the first file that needs to be cleaned or smudged, it starts the filter and performs the handshake. In the handshake, the welcome message sent by Git is "git-filter-client", only version 2 is supported, and the supported capabilities are "clean", "smudge", and "delay".
- (Some details about the protocol in docs ... ignore here)