"""
push2emerge.py  —  Push an HTML file to aknoesen/ECE-Emerge on GitHub Pages.

Usage:
    python push2emerge.py "path\to\file.html"

If no argument is given the script will prompt for the path.

The script maintains a persistent local clone of the repo at:
    %LOCALAPPDATA%\\ECE-Emerge-clone
so it only clones once; subsequent runs do a fast `git pull` instead.

Destination mapping (source path → repo path):
  Lab Manuals/Lab[N]/htmlconversion/…        → Lab[N]/htmlconversion/…
  Lab Manuals/EquipmentInstructions/…        → EquipmentInstructions/…
  Lab Manuals/Project/…                      → Project/…
  Module Descriptors/htmlconversion/….html   → Module Descriptors/….html
  Reader/*/htmlconversion/….html             → Reader/….html
  Anything else with htmlconversion/….html   → ….html  (repo root)
"""

import os
import sys
import shutil
import subprocess
from pathlib import Path
from datetime import datetime

# ── Configuration ────────────────────────────────────────────────────────────
REPO_URL    = "git@github.com:aknoesen/ECE-Emerge.git"
REPO_OWNER  = "aknoesen"
REPO_NAME   = "ECE-Emerge"
BRANCH      = "main"

# Root of the local ADA Compliant Webpage Materials working directory
SOURCE_ROOT = Path(r"C:\Users\admin-aknoesen\Documents\EEC1 Spring 2026\ADA Compliant Webpage Materials")

# Persistent clone lives next to LOCALAPPDATA so it survives reboots
LOCAL_CLONE = Path(os.environ.get("LOCALAPPDATA", Path.home())) / "ECE-Emerge-clone"
# ─────────────────────────────────────────────────────────────────────────────


def repo_dest(src: Path) -> Path:
    """Map a source file path to its destination path within the git repo."""
    try:
        rel = src.relative_to(SOURCE_ROOT)
    except ValueError:
        # Source is outside SOURCE_ROOT — fall back to filename at repo root
        print(f"[WARN] Source is outside SOURCE_ROOT; placing at repo root.")
        return Path(src.name)

    parts = list(rel.parts)

    # Strip leading "Lab Manuals" — keep the rest of the path intact
    # e.g. Lab Manuals/Lab3/htmlconversion/Lab3Instructions.html
    #   →  Lab3/htmlconversion/Lab3Instructions.html
    if parts[0] == "Lab Manuals":
        return Path(*parts[1:])

    # Module Descriptors: strip the htmlconversion subdirectory
    # e.g. Module Descriptors/htmlconversion/Module 3 Descriptor.html
    #   →  Module Descriptors/Module 3 Descriptor.html
    if parts[0] == "Module Descriptors":
        filtered = [p for p in parts if p != "htmlconversion"]
        return Path(*filtered)

    # Reader: flatten subdir + htmlconversion → Reader/filename.html
    # e.g. Reader/ACAnalysis/htmlconversion/ACAnalysis.html
    #   →  Reader/ACAnalysis.html
    if parts[0] == "Reader":
        return Path("Reader") / src.name

    # Everything else (Homepage, course pages, etc.): filename at repo root
    return Path(src.name)


def run(cmd: list[str], cwd: Path) -> str:
    """Run a git command, print it, raise on failure."""
    print("  git", " ".join(cmd[1:]))
    result = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
    if result.returncode != 0:
        print(result.stderr.strip())
        raise RuntimeError(f"Command failed: {' '.join(cmd)}")
    return result.stdout.strip()


def ensure_clone() -> Path:
    """Clone the repo if it doesn't exist locally, otherwise pull latest."""
    if LOCAL_CLONE.exists():
        print(f"[INFO] Using existing clone at {LOCAL_CLONE}")
        run(["git", "pull", "--ff-only", "origin", BRANCH], cwd=LOCAL_CLONE)
    else:
        print(f"[INFO] Cloning {REPO_URL} -> {LOCAL_CLONE}")
        subprocess.run(
            ["git", "clone", REPO_URL, str(LOCAL_CLONE)],
            check=True
        )
    return LOCAL_CLONE


def push_file(src: Path) -> None:
    src = src.resolve()          # make absolute so repo_dest() can compare to SOURCE_ROOT
    if not src.exists():
        print(f"[ERROR] File not found: {src}")
        sys.exit(1)

    if src.suffix.lower() != ".html":
        print(f"[WARN] File does not have .html extension: {src.name}")

    repo = ensure_clone()
    rel_dest = repo_dest(src)
    dest = repo / rel_dest

    # Ensure destination directory exists
    dest.parent.mkdir(parents=True, exist_ok=True)

    shutil.copy2(src, dest)
    print(f"[INFO] Copied  {src.name}  ->  {rel_dest}")

    # Stage
    run(["git", "add", str(rel_dest)], cwd=repo)

    # Check if there is actually a diff to commit
    status = subprocess.run(
        ["git", "status", "--porcelain", str(rel_dest)],
        cwd=repo, capture_output=True, text=True
    ).stdout.strip()

    if not status:
        print("[INFO] No changes detected — file already up to date on GitHub.")
        return

    # Commit
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")
    msg = (
        f"Update {rel_dest}\n\n"
        f"Pushed via push2emerge.py at {timestamp}\n\n"
        f"Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
    )
    run(["git", "commit", "-m", msg], cwd=repo)

    # Push
    run(["git", "push", "origin", BRANCH], cwd=repo)

    url_path = str(rel_dest).replace("\\", "/").replace(" ", "%20")
    pages_url = f"https://{REPO_OWNER.lower()}.github.io/{REPO_NAME}/{url_path}"
    print()
    print(f"[OK]  {rel_dest}  pushed to GitHub Pages.")
    print(f"      URL: {pages_url}")


def main():
    if len(sys.argv) > 1:
        src = Path(sys.argv[1])
    else:
        raw = input("Enter path to HTML file: ").strip().strip('"')
        src = Path(raw)

    push_file(src)


if __name__ == "__main__":
    main()
