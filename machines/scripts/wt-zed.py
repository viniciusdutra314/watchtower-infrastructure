#!/bin/env python

import os
import sys
from pathlib import Path, PurePath
from typing import Literal, NoReturn

# local => remote
PATH_TRANSLATION: dict[Path, PurePath] = {
    Path("/home/vinicius/coding/watchtower-dev"): PurePath("/home/chloe/projects")
}
SSH_ALIAS = "watchtower-dev"

def translate_path_and_launch_editor(
    editor: Literal["codium", "zed"],
) -> NoReturn:
    args = sys.argv[1:]
    if len(sys.argv) != 1:
        path_to_open = (Path.cwd() / Path(sys.argv[1])).resolve()
        for local_root, remote_root in PATH_TRANSLATION.items():
            if not path_to_open.is_relative_to(local_root):
                continue
            suffix = path_to_open.relative_to(local_root)
            remote_path = remote_root / suffix
            match editor:
                case "codium":
                    uri = f"vscode-remote://ssh-remote+{SSH_ALIAS}{remote_path}"
                    os.execvp(editor, [editor, "--folder-uri", uri, *args[1:]])
                case "zed":
                    uri = f"ssh://{SSH_ALIAS}{remote_path}"
                    os.execvp(editor, [editor, uri, *args[1:]])
    os.execvp(editor, [editor, *args])


translate_path_and_launch_editor("zeditor")
