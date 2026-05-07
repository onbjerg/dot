#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: search.sh [options] <query>

Search DuckDuckGo HTML from the terminal. Results are fetched through curl.md
by default for token-efficient output.

Options:
  --site <domain>     Restrict search to a site, e.g. github.com
  --region <kl>       DuckDuckGo region/language, e.g. us-en
  --offset <n>        Result offset, e.g. 30 for page 2 or 60 for page 3
  --page <n>          Page number; converts to offset (page 1 = offset 0)
  --urls              Print cleaned result titles and target URLs, then exit
  --direct            Fetch DuckDuckGo HTML directly instead of curl.md
  --print-url         Print the generated fetch URL and exit
  -h, --help          Show this help

Examples:
  bash search.sh "openai api"
  bash search.sh --region us-en "openai api"
  bash search.sh --site github.com "duckdb"
  bash search.sh --offset 30 "openai"
  bash search.sh --page 3 "openai"
  bash search.sh --urls "Ethereum Glamsterdam EIPs"
USAGE
}

site=""
region=""
offset=""
use_curl_md=1
print_url=0
urls_only=0
args=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --site)
      [[ $# -ge 2 ]] || { echo "missing value for --site" >&2; exit 2; }
      site="$2"
      shift 2
      ;;
    --region|--kl)
      [[ $# -ge 2 ]] || { echo "missing value for $1" >&2; exit 2; }
      region="$2"
      shift 2
      ;;
    --offset|-s)
      [[ $# -ge 2 ]] || { echo "missing value for $1" >&2; exit 2; }
      offset="$2"
      shift 2
      ;;
    --page)
      [[ $# -ge 2 ]] || { echo "missing value for --page" >&2; exit 2; }
      page="$2"
      if ! [[ "$page" =~ ^[0-9]+$ ]] || [[ "$page" -lt 1 ]]; then
        echo "--page must be a positive integer" >&2
        exit 2
      fi
      offset=$(( (page - 1) * 30 ))
      shift 2
      ;;
    --urls)
      urls_only=1
      shift
      ;;
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
      args+=("$@")
      break
      ;;
    -*)
      echo "unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      args+=("$1")
      shift
      ;;
  esac
done

if [[ ${#args[@]} -eq 0 ]]; then
  echo "missing query" >&2
  usage >&2
  exit 2
fi

query="${args[*]}"
if [[ -n "$site" ]]; then
  query="site:${site} ${query}"
fi

url=$(python3 - "$query" "$region" "$offset" <<'PY'
import sys
from urllib.parse import urlencode

query, region, offset = sys.argv[1], sys.argv[2], sys.argv[3]
params = {"q": query}
if region:
    params["kl"] = region
if offset and offset != "0":
    params["s"] = offset
print("https://html.duckduckgo.com/html/?" + urlencode(params))
PY
)

if [[ "$urls_only" -eq 1 ]]; then
  fetch_url=$(python3 - "$url" <<'PY'
import sys
from urllib.parse import quote
print("https://curl.md/" + quote(sys.argv[1], safe=""))
PY
)
  tmp=$(mktemp)
  trap 'rm -f "$tmp"' EXIT
  curl -Ls "$fetch_url" > "$tmp"
  python3 - "$tmp" <<'PY'
import html
import re
import sys
from urllib.parse import parse_qs, unquote, urlparse

def clean_url(href):
    href = html.unescape(href).replace("\\&", "&")
    if href.startswith("//"):
        href = "https:" + href
    parsed = urlparse(href)
    if "duckduckgo.com" in parsed.netloc and parsed.path.startswith("/l/"):
        target = parse_qs(parsed.query).get("uddg", [href])[0]
        return unquote(target)
    return href

with open(sys.argv[1], encoding="utf-8") as f:
    for line in f:
        match = re.match(r"^## \[(.*?)\]\((.*?)\)", line.strip())
        if not match:
            continue
        title, href = match.groups()
        title = re.sub(r"\\(.)", r"\1", html.unescape(title))
        print(f"{title}\n  {clean_url(href)}\n")
PY
  exit 0
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
