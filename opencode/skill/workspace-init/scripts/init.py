#!/usr/bin/env python3
"""
Creates an isolated jj workspace for agent threads.

Usage: init.py <cwd> <workspace-name> [base-revision]

Exit codes:
  0 - Success (prints workspace path)
  1 - Already in non-default workspace (prints current workspace name)
  2 - Cannot determine workspace root
  3 - Workspace already exists (collision)
"""

import subprocess
import sys
from pathlib import Path


def run(cmd: list[str], cwd: Path | None = None) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)


def get_current_workspace(cwd: Path) -> str:
    result = run(["jj", "workspace", "list"], cwd=cwd)
    if result.returncode != 0:
        return "default"

    for line in result.stdout.splitlines():
        # Format: "name: changeid description" or "* name: ..."
        line = line.lstrip("* ").strip()
        if ":" in line:
            return line.split(":")[0].strip()
    return "default"


def get_workspace_root(cwd: Path) -> tuple[Path, Path] | None:
    """Returns (workspace_root, projects_root) or None if not determinable."""
    cwd_str = str(cwd)

    if cwd_str.startswith("/media/vault/Projects"):
        return Path("/media/vault/Workspaces"), Path("/media/vault/Projects")

    if cwd_str.startswith("/Users/"):
        parts = cwd_str.split("/")
        if len(parts) >= 4 and parts[3] == "Projects":
            home = Path(f"/Users/{parts[2]}")
            return home / "Workspaces", home / "Projects"

    if cwd_str.startswith("/home/"):
        parts = cwd_str.split("/")
        if len(parts) >= 4 and parts[3] == "Projects":
            home = Path(f"/home/{parts[2]}")
            return home / "Workspaces", home / "Projects"

    return None


def extract_org_repo(cwd: Path, proj_root: Path) -> str:
    """Extract org/repo from the path."""
    rel = cwd.relative_to(proj_root)
    parts = rel.parts
    if len(parts) >= 2:
        return f"{parts[0]}/{parts[1]}"
    return str(rel)


def get_trunk(cwd: Path) -> str:
    """Get trunk revision using jj's trunk() revset."""
    return "trunk()"


def main():
    if len(sys.argv) < 3:
        print("Usage: init.py <cwd> <workspace-name> [base-revision]", file=sys.stderr)
        sys.exit(1)

    cwd = Path(sys.argv[1]).resolve()
    name = sys.argv[2]
    base_rev = sys.argv[3] if len(sys.argv) > 3 else None

    # Check if already in non-default workspace
    current_ws = get_current_workspace(cwd)
    if current_ws != "default":
        print(current_ws)
        sys.exit(1)

    # Determine workspace root
    roots = get_workspace_root(cwd)
    if roots is None:
        print(f"Cannot determine workspace root for: {cwd}", file=sys.stderr)
        sys.exit(2)

    ws_root, proj_root = roots
    org_repo = extract_org_repo(cwd, proj_root)
    ws_path = ws_root / org_repo / name

    # Check for collision
    if ws_path.exists():
        print(f"Workspace already exists: {ws_path}", file=sys.stderr)
        sys.exit(3)

    # Create workspace
    ws_path.parent.mkdir(parents=True, exist_ok=True)
    result = run(["jj", "workspace", "add", str(ws_path), "--name", name], cwd=cwd)
    if result.returncode != 0:
        print(f"Failed to create workspace: {result.stderr}", file=sys.stderr)
        sys.exit(1)

    # Create new change based on specified revision or trunk
    revision = base_rev if base_rev else get_trunk(ws_path)
    run(["jj", "new", revision], cwd=ws_path)

    print(ws_path)


if __name__ == "__main__":
    main()
