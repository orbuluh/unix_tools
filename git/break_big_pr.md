# Break big PR into several smaller one

Say you have main

```txt
main: ...M
```

You branch out and create branch X

```txt
X: ...M -> a -> b -> c -> d -> e
```

All the changes from commit `a` to  commit `e` is too much for one PR.
And you need to break it down.

Say the first batch, you want to include commit `a` -> `b` -> `c`

You could:

1. Branch out a branch Y

```txt
Y: ...M -> a -> b -> c -> d -> e
```

2. Use iterative rebase and remove the commit history for `d` and `e`

```bash
git rebase -i M
# in the text editor remove commit d and e from iterative rebase
```

Then you can create PR for branch Y.

Here, say, when merging to M you need to squash the changes on Y

```
(after squashing a->b->c to s1 and commit into origin main)
remote-main: ...M -> s1
```

How do you bring back the changes of commit S to branch X?

Note that if you try to `git rebase origin master` on X, there could be lots of conflict that you need to resolve from a/b/c v.s. S (even though they represent the same diff)


One easy way is on branch X, you do a iterative rebase on M and squash `a->b->c` on X

```bash
git rebase -i M
# in the text editor, pick commit a and squash the commit b and c
```

Say X locally becomes

```txt
X: ...M -> S' -> d -> e
```

Now, if you do a `git pull origin main` with rebase mode, it will successfully find out that `S'` on X is the same as `S` on main, it will do a fast-forward and replace `S'` with `S` on branch X!

```
(after git pull origin master with rebase mode)
X: ...M -> S -> d -> e
```

And now, you can create the second batch for `d`->`e`!


























