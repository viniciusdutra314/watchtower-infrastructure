#!/bin/env python
from pathlib import Path
from shlex import join
from subprocess import DEVNULL, run

run_as_chloe = lambda command: run(
    ["ssh", "watchtower-dev-chloe", join(command)], check=True, stdin=DEVNULL
)

repo_name = Path(
    run(
        ["git", "rev-parse", "--show-toplevel"],
        capture_output=True,
        text=True,
        check=True,
    ).stdout.strip()
).name
commit_sha1 = run(
    ["git", "rev-parse", "--short=12", "HEAD"],
    capture_output=True,
    text=True,
    check=True,
).stdout.strip()
bare_path = f"/home/chloe/repos/{repo_name}.git"
remote_url = f"ssh://watchtower-dev-chloe{bare_path}"

# create bare repo
run_as_chloe(["mkdir", "-p", "/home/chloe/repos"])
run_as_chloe(["git", "init", "--bare", bare_path])
# push changes
run(
    [
        "git",
        "push",
        remote_url,
        "HEAD:refs/heads/codex-inbox",
    ],
    check=True,
)
# create worktree
worktree_parent = f"/home/chloe/worktrees/{repo_name}"
worktree_path = f"{worktree_parent}/{commit_sha1}"

run_as_chloe(["mkdir", "-p", worktree_parent])

worktree_exists = (
    run(
        [
            "ssh",
            "watchtower-dev-chloe",
            join(["test", "-d", worktree_path]),
        ],
        check=True,
    ).returncode
    == 0
)

if not worktree_exists:
    run_as_chloe(
        [
            "git",
            f"--git-dir={bare_path}",
            "worktree",
            "add",
            "--detach",
            worktree_path,
            commit_sha1,
        ]
    )

run_as_codex = lambda prompt: run_as_chloe(
    [
        "/home/chloe/.local/bin/codex",
        "exec",
        "-C",
        worktree_path,
        "--sandbox",
        "workspace-write",
        prompt,
    ]
)
run_as_codex("quem é você?")
