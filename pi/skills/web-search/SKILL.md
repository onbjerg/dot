---
name: web-search
description: "Search the web from the terminal using DuckDuckGo HTML and curl.md for token-efficient results. Use when current web information, docs, issues, or site-restricted search is needed."
---

# Web Search

Use DuckDuckGo's HTML endpoint for web searches. Prefer the helper scripts in this skill directory because they URL-encode inputs and wrap requests with `curl.md` by default to save tokens.

Skill directory:

```bash
/Users/oliver/.pi/agent/skills/web-search
```

## Recommended workflow

1. Search for likely sources:
   ```bash
   bash /Users/oliver/.pi/agent/skills/web-search/search.sh "Ethereum Glamsterdam EIPs"
   ```
2. If you only need clean result links, use URL extraction:
   ```bash
   bash /Users/oliver/.pi/agent/skills/web-search/search.sh --urls "Ethereum Glamsterdam EIPs"
   ```
3. Pick a promising result URL and read it:
   ```bash
   bash /Users/oliver/.pi/agent/skills/web-search/fetch.sh 'https://ethereum.org/roadmap/glamsterdam/'
   ```
4. If `curl.md` output is incomplete, stripped, blocked, or only metadata, retry direct:
   ```bash
   bash /Users/oliver/.pi/agent/skills/web-search/fetch.sh --direct 'https://example.com/page'
   ```
5. For source code, raw files, docs, or repositories, switch to more precise tools after locating them: raw URLs, package docs, `gh`, or the `librarian` skill for remote git repositories.

## Search helper

```bash
bash /Users/oliver/.pi/agent/skills/web-search/search.sh "openai api"
bash /Users/oliver/.pi/agent/skills/web-search/search.sh --region us-en "openai api"
bash /Users/oliver/.pi/agent/skills/web-search/search.sh --site github.com "duckdb"
bash /Users/oliver/.pi/agent/skills/web-search/search.sh --offset 30 "openai"
bash /Users/oliver/.pi/agent/skills/web-search/search.sh --page 3 "openai"
bash /Users/oliver/.pi/agent/skills/web-search/search.sh --urls "Ethereum Glamsterdam EIPs"
```

The search helper builds a DuckDuckGo URL and fetches it through `curl.md` by default. Use `--direct` when raw DuckDuckGo HTML is needed, or `--print-url` to inspect the generated URL without fetching.

`--urls` prints cleaned result titles and target URLs. It intentionally parses `curl.md` output because direct DuckDuckGo requests can trigger bot challenges.

## Reading result pages

After finding a promising result URL, fetch that page too. Prefer `fetch.sh`, which wraps the target URL with `curl.md` by default:

```bash
bash /Users/oliver/.pi/agent/skills/web-search/fetch.sh 'https://docs.rs/tokio/latest/tokio/'
bash /Users/oliver/.pi/agent/skills/web-search/fetch.sh 'https://github.com/duckdb/duckdb'
bash /Users/oliver/.pi/agent/skills/web-search/fetch.sh --print-url 'https://github.com/duckdb/duckdb'
```

Use `--direct` only when `curl.md` strips information needed for the task or the target site blocks `curl.md`:

```bash
bash /Users/oliver/.pi/agent/skills/web-search/fetch.sh --direct 'https://example.com/'
```

## When curl.md is insufficient

`curl.md` is usually best for token efficiency, but it can:

- strip interactive or script-rendered content
- return only page metadata for single-page apps
- be blocked by Cloudflare or other bot protection
- omit raw/source content that matters for correctness

If that happens:

1. Retry with `fetch.sh --direct <url>`.
2. For SPAs, inspect the raw HTML for hints like `/llms.txt`, `/llms-full.txt`, static JSON, or API/data bundle paths.
3. Try common LLM/document endpoints:
   ```bash
   bash /Users/oliver/.pi/agent/skills/web-search/fetch.sh 'https://example.com/llms.txt'
   bash /Users/oliver/.pi/agent/skills/web-search/fetch.sh 'https://example.com/llms-full.txt'
   ```
4. For GitHub/repositories, prefer `gh` or the `librarian` skill over scraping rendered pages.
5. For raw files, fetch direct raw URLs rather than through `curl.md` if `curl.md` is blocked or reformats important content.

## Manual DuckDuckGo queries

Basic search:

```bash
curl -L 'https://html.duckduckgo.com/html/?q=openai+api'
```

Search with region/language:

```bash
curl -L 'https://html.duckduckgo.com/html/?q=openai+api&kl=us-en'
```

Site-restricted search:

```bash
curl -L 'https://html.duckduckgo.com/html/?q=site%3Agithub.com+duckdb'
```

Pagination uses the `s` offset parameter, usually in increments of 30:

```bash
curl -L 'https://html.duckduckgo.com/html/?q=openai&s=30'
curl -L 'https://html.duckduckgo.com/html/?q=openai&s=60'
```

Combined example:

```bash
curl -L 'https://html.duckduckgo.com/html/?q=site%3Agithub.com+openai&kl=us-en&s=30'
```

## Token-efficient output with curl.md

To reduce tokens, prefix the fully constructed search URL with `https://curl.md/` and URL-encode the full original URL:

```bash
python3 - <<'PY'
from urllib.parse import quote
url = 'https://html.duckduckgo.com/html/?q=openai+api&kl=us-en'
print('https://curl.md/' + quote(url, safe=''))
PY
```

Then fetch the printed URL:

```bash
curl -L '<printed curl.md URL>'
```

## Notes

- Quote shell URLs and queries.
- Use `site:<domain>` in the query for site-restricted searches.
- Use `kl=<region-language>` for localization, for example `us-en`.
- Use `s=30`, `s=60`, etc. for later search result pages.
- Fetch result pages with `fetch.sh '<url>'`; it uses `curl.md` by default.
- Prefer official/primary sources when summarizing facts.
