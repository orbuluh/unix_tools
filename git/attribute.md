# [gitattributes](https://git-scm.com/docs/gitattributes)

## Quick intro
- `gitattributes` file is a simple text file that gives **attributes to pathnames. Certain operations by Git can be influenced by assigning particular attributes to a path.**
- When the pattern matches the path in question, the attributes listed on the line are given to the path.
- When more than one pattern matches the path, a later line overrides an earlier line. This overriding is done per attribute.
- The rules by which the pattern matches paths are the same as in `.gitignore`
- When deciding what attributes are assigned to a path, Git consults following files in orders:
  - `$GIT_DIR/info/attributes`
  - `.gitattributes` file in the same directory as the path in question, and
  - its parent directories up to the toplevel of the work tree (the further the directory that contains `.gitattributes`
  - Finally global and system-wide files are considered.