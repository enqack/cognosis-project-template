# Cognosis Project Template

## Purpose

This template turns any repository — any language, any purpose — into a
[Cognosis](https://github.com/enqack/cognosis)-tracked project. Sessions in a
tracked repo get the project's knowledge index injected at start, and durable
findings are captured back into the central vault at session end. The repo
itself stays clean: all knowledge lives in the Cognosis vault, not here.

## What's in the template

| File | Role |
|------|------|
| `.cognosis-project` | One-line marker file; its content is the project tag attached to every note. Its presence gates all hooks — repos without it are untouched. |
| `.claude/settings.json` | Wires the SessionStart and SessionEnd hooks into Claude Code. |
| `.claude/hooks/cognosis-session-start-inject.sh` | Injects the project-scoped knowledge index at session start (`cognosis context inject`). |
| `.claude/hooks/cognosis-session-end-nudge.sh` | Runs one headless turn at session end nudging the agent to persist durable findings as notes or reflections. |
| `.claude/hooks/cognosis-post-commit.sh` | Opt-in git commit capture. **Not active** until you install it into `.git/hooks/post-commit` (see below). |

## Prerequisites

A running Cognosis daemon and the MCP server registered in Claude Code. Full
setup (Postgres + pgvector, Ollama, configuration) is covered in the
[Cognosis setup guide](https://github.com/enqack/cognosis/blob/main/docs/setup-guide.md).
The short version:

```sh
cognosis start
claude mcp add --transport http cognosis http://127.0.0.1:7433 \
  --header "Authorization: Bearer $(cat ~/.local/state/cognosis/local-token)"
```

## Getting started

### New project

1. Use this repo as a template (or clone it and remove the git history).
2. Set the project tag — this is the name notes will be filed under:

   ```sh
   echo "my-project-name" > .cognosis-project
   ```

3. Replace this README and start building. The hooks need no further setup.

### Existing repo

1. Copy `.cognosis-project` and the `.claude/` directory into the repo root.
2. Set the project tag in `.cognosis-project` as above.
3. If the repo already has a `.claude/settings.json`, merge the `hooks`
   entries from this template's copy instead of overwriting.

## Optional: commit capture

Each commit can be captured as a structured entry in the vault. Enable it per
repo:

```sh
cp .claude/hooks/cognosis-post-commit.sh .git/hooks/post-commit
chmod +x .git/hooks/post-commit
```

The hook is marker-gated and never fails a commit — a broken capture prints a
warning and moves on.

## Configuration

- `COGNOSIS_INJECT_BUDGET` — token budget for the injected knowledge index
  (default `2000`).

Both session hooks are gated by the `.cognosis-project` marker: outside a
marked repo they exit silently and never contact the daemon. Inside a marked
repo the start hook fails loud if the daemon is unreachable — a context-less
session that looks normal is worse than one that visibly fails.

## How it works

The project tag flows into the frontmatter of every note the agent writes.
During a session the agent reads and writes memory through the Cognosis MCP
tools (`query_knowledge`, `write_note`, `edit_note`, `write_reflection`, …).
The vault is a central, git-versioned markdown tree under
`$XDG_DATA_HOME/cognosis/kb/` — nothing knowledge-related is stored in this
repository. See the
[Cognosis architecture docs](https://github.com/enqack/cognosis/blob/main/docs/architecture.md)
for the full picture.

## License

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org/>
