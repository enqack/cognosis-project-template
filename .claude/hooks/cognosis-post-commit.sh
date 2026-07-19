#!/usr/bin/env bash
# Opt-in git commit capture. Not active until installed into .git/hooks:
#   cp .claude/hooks/cognosis-post-commit.sh .git/hooks/post-commit
#   chmod +x .git/hooks/post-commit
#
# Marker-gated: `cognosis hook post-commit` exits 0 silently in repos without
# a .cognosis-project marker, and never fails the commit — a broken capture
# prints a warning and moves on.
exec cognosis hook post-commit
