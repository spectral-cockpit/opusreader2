# Agent instructions

## Change summaries

All commit messages must follow [Conventional Commits](https://www.conventionalcommits.org/).
Use a type prefix: `feat`, `fix`, `refactor`, `chore`, `docs`, `style`, `test`, `perf`, or `ci`.
Examples: `feat(filen): add whoami command`, `fix(path-guard): block filen credentials`, `chore: update prek config`.
Use a scope in parentheses when the change is scoped to a specific module or file; omit it for cross-cutting changes.

Use the imperative present tense for the subject and body, as is standard for git commits and PRs.
Write "switch formatter to `nixfmt-tree`", not "switched formatter to `nixfmt-tree`" or "switches formatter to `nixfmt-tree`".
This applies to bullet lists in summaries too: each bullet should read as an instruction completing the sentence "This change will…".

## Prose style

In Markdown and other prose files, write one sentence per line.
Do not hard-wrap sentences across multiple lines and do not join multiple sentences onto one line.
This keeps diffs minimal and reviewable.

## Code block comments

Inside fenced code blocks (e.g. shell examples), put comments on their own line *above* the command, prefixed with `#`.
Do not use trailing `# comment` after a command.

## Formatting and linting

When editing `.R` files, use both the `air` formatter and the `jarl` linter.
Invoke them via `just format` and `just fix`

## PR summary

After every `git push` that completes a PR branch, output a Markdown summary of what was done, then call the `copy_to_clipboard` tool with that summary so it lands on the clipboard ready to paste.
The summary must include:

- **Branch / PR:** branch name and the PR URL printed by `git push`.
- **Summary** one sentence describing the motivation.
- **What changed:** a bullet list of every file modified and what was changed in it.
- **Behaviour change:** a short description of how the system behaves differently after the change.

## Pre-commit (prek)

`prek` is already installed via `home.nix`, so use it directly — do **not** invoke it through `nix run nixpkgs#prek`. Config lives in `prek.toml`.

Useful commands:

```sh
# run all hooks on all files
prek run -a
# validate the prek config itself
prek validate-config prek.toml
```

