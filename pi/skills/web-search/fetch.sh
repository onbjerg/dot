#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: fetch.sh [options] <url>

Fetch a web page from the terminal. Uses curl.md by default for token-efficient,
markdown-like output.

Options:
  --direct            Fetch the URL directly instead of through curl.md
  --print-url         Print the generated fetch URL and exit
  -h, --help          Show this help

Examples:
  bash fetch.sh 'https://docs.rs/tokio/latest/tokio/'
  bash fetch.sh --direct 'https://example.com/'
  bash fetch.sh --print-url 'https://github.com/duckdb/duckdb'
USAGE
}

use_curl_md=1
print_url=0
url=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --direct)
      use_curl_md=0
      shift
      ;;
    --print-url)
      print_url=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      [[ $# -eq 1 ]] || { echo "expected exactly one URL" >&2; exit 2; }
      url="$1"
      shift
      ;;
    -*)
      echo "unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      if [[ -n "$url" ]]; then
        echo "expected exactly one URL" >&2
        usage >&2
        exit 2
      fi
      url="$1"
      shift
      ;;
  esac
done

if [[ -z "$url" ]]; then
  echo "missing URL" >&2
  usage >&2
  exit 2
fi

fetch_url="$url"
if [[ "$use_curl_md" -eq 1 ]]; then
  fetch_url=$(python3 - "$url" <<'PY'
import sys
from urllib.parse import quote
print("https://curl.md/" + quote(sys.argv[1], safe=""))
PY
)
fi

if [[ "$print_url" -eq 1 ]]; then
  printf '%s\n' "$fetch_url"
  exit 0
fi

curl -L "$fetch_url"
