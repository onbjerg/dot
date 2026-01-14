#!/usr/bin/env python3
"""
Lists stale workspaces as JSON.

Usage: list_stale.py <cwd>

A workspace is stale if older than 7 days OR has all bookmarks pushed.

Output: JSON array of stale workspaces
Exit codes:
  0 - Success (prints JSON array, may be empty)
  2 - Cannot determine workspace root
"""

import json
import subprocess
import sys
import time
from pathlib import Path

STALE_DAYS = 7


def run(cmd: list[str], cwd: Path | None = None) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)


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


def has_unpushed_bookmarks(ws_path: Path) -> bool:
    """Check if workspace has unpushed bookmarks."""
    result = run(
        ["jj", "log", "-r", "bookmarks() & ~remote_bookmarks()", "--no-graph", "-T", "change_id"],
        cwd=ws_path
    )
    return bool(result.stdout.strip())


def main():
    if len(sys.argv) != 2:
        print("Usage: list_stale.py <cwd>", file=sys.stderr)
        sys.exit(1)
    
    cwd = Path(sys.argv[1]).resolve()
    
    # Determine workspace root
    roots = get_workspace_root(cwd)
    if roots is None:
        print(f"Cannot determine workspace root for: {cwd}", file=sys.stderr)
        sys.exit(2)
    
    ws_root, proj_root = roots
    org_repo = extract_org_repo(cwd, proj_root)
    ws_dir = ws_root / org_repo
    
    # If workspace directory doesn't exist, return empty array
    if not ws_dir.exists():
        print("[]")
        return
    
    now = time.time()
    stale = []
    
    for ws_path in ws_dir.iterdir():
        if not ws_path.is_dir():
            continue
        
        mtime = ws_path.stat().st_mtime
        age_days = int((now - mtime) / 86400)
        reason = None
        
        # Check age-based staleness
        if age_days > STALE_DAYS:
            reason = "age"
        # Check if all bookmarks are pushed
        elif not has_unpushed_bookmarks(ws_path):
            reason = "pushed"
        
        if reason:
            stale.append({
                "name": ws_path.name,
                "path": str(ws_path),
                "age_days": age_days,
                "reason": reason
            })
    
    print(json.dumps(stale))


if __name__ == "__main__":
    main()
