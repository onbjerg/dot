#!/usr/bin/env python3
"""
Deletes a workspace and cleans up empty parent directories.

Usage: delete.py <main-repo-cwd> <workspace-name> <workspace-path>

Exit codes:
  0 - Success
"""

import shutil
import subprocess
import sys
from pathlib import Path


def run(cmd: list[str], cwd: Path | None = None) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)


def main():
    if len(sys.argv) != 4:
        print(
            "Usage: delete.py <main-repo-cwd> <workspace-name> <workspace-path>",
            file=sys.stderr,
        )
        sys.exit(1)

    main_cwd = Path(sys.argv[1]).resolve()
    ws_name = sys.argv[2]
    ws_path = Path(sys.argv[3]).resolve()

    # Forget the workspace from jj
    run(["jj", "workspace", "forget", ws_name], cwd=main_cwd)

    # Remove the workspace directory
    if ws_path.exists():
        shutil.rmtree(ws_path)

    # Clean up empty parent directories
    parent = ws_path.parent
    grandparent = parent.parent

    try:
        if parent.exists() and not any(parent.iterdir()):
            parent.rmdir()
        if grandparent.exists() and not any(grandparent.iterdir()):
            grandparent.rmdir()
    except OSError:
        pass  # Directory not empty or other error, ignore

    print(f"Deleted workspace: {ws_name}")


if __name__ == "__main__":
    main()
