#!/bin/env python
import argparse
from ast import arg
from pathlib import Path, PurePosixPath
from shlex import join
from subprocess import DEVNULL, run


def run_as_chloe(command: list[str]) -> None:
    run(["ssh", "watchtower-dev-chloe", join(command)], check=True, stdin=DEVNULL)


def run_as_codex(prompt: str, worktree_path: PurePosixPath) -> None:
    run_as_chloe(
        [
            "/home/chloe/.local/bin/codex",
            "exec",
            "-C",
            str(worktree_path),
            "--sandbox",
            "workspace-write",
            prompt,
        ]
    )


REPO_NAME: str = Path(
    run(
        ["git", "rev-parse", "--show-toplevel"],
        capture_output=True,
        text=True,
        check=True,
    ).stdout.strip()
).name
COMMIT_SHA1: str = run(
    ["git", "rev-parse", "--short=12", "HEAD"],
    capture_output=True,
    text=True,
    check=True,
).stdout.strip()
BARE_PATH = PurePosixPath("/home/chloe/repos", f"{REPO_NAME}.git")
WORKTREE_PARENT = PurePosixPath("/home/chloe/worktrees", REPO_NAME)
WORKTREE_PATH = WORKTREE_PARENT / COMMIT_SHA1
REMOTE_URL = f"ssh://watchtower-dev-chloe{BARE_PATH}"


def main() -> None:
    parser = argparse.ArgumentParser(
        prog="watchtower-review",
        description="Call codex on watchtower-dev to review code",
    )
    args = parser.parse_args()

    # create bare repo
    run_as_chloe(["mkdir", "-p", "/home/chloe/repos"])
    run_as_chloe(["git", "init", "--bare", str(BARE_PATH)])
    # push changes
    run(
        [
            "git",
            "push",
            REMOTE_URL,
            "HEAD:refs/heads/codex-inbox",
        ],
        check=True,
    )
    # create worktree
    run_as_chloe(["mkdir", "-p", str(WORKTREE_PARENT)])
    worktree_exists = (
        run(
            [
                "ssh",
                "watchtower-dev-chloe",
                join(["test", "-d", str(WORKTREE_PATH)]),
            ],
            check=False,
        ).returncode
        == 0
    )

    if not worktree_exists:
        run_as_chloe(
            [
                "git",
                f"--git-dir={BARE_PATH}",
                "worktree",
                "add",
                "--detach",
                str(WORKTREE_PATH),
                COMMIT_SHA1,
            ]
        )

    run_as_codex(
        f"""Revise o commit Git {COMMIT_SHA1}.

    Inspecione o diff, a mensagem do commit e o contexto
    necessário para compreender as alterações.

    Considere as Skills instaladas cujos nomes começam
    com watchtower-review-.

    Selecione e execute somente as Skills pertinentes às
    alterações identificadas. Pode utilizar múltiplas Skills
    quando elas avaliarem aspectos distintos do commit.

    Não escolha Skills apenas pela mensagem ou pelo tamanho
    do commit. Evite revisões redundantes.

    Execute revisões custosas sequencialmente para reduzir
    a interferência entre benchmarks.

    Não altere o código do autor nem crie commits.

    Ao concluir, informe:
    - Skills selecionadas e justificativas.
    - Revisões realizadas e resultados.
    - Revisões que falharam ou ficaram inconclusivas.
    - Caminhos dos relatórios e artefatos.
    """,
        WORKTREE_PATH,
    )


if __name__ == "__main__":
    main()
