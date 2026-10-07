#!/usr/bin/env bash
# Count the characters (including spaces) of a upolthesis document's text,
# from the first chapter after the front matter up to the bibliography or
# appendices, and write the result to <jobname>.chars for the next run.
# Usage: upol-count.sh thesis   (after a LaTeX run that produced thesis.pdf)
set -euo pipefail

job="${1%.tex}"
aux="$job.aux"
pdf="$job.pdf"
[[ -f "$aux" && -f "$pdf" ]] || { echo "upol-count: need $aux and $pdf" >&2; exit 1; }

abspage() {
  grep -F "zref@newlabel{$1}" "$aux" | grep -o 'abspage{[0-9]*}' | grep -o '[0-9]\+' | head -1
}
first=$(abspage upol@textstart || true)
last=$(abspage upol@textlast || true)
if [[ -z "$first" || -z "$last" ]]; then
  echo "upol-count: page labels not in $aux yet; run LaTeX again" >&2
  exit 0
fi

chars=$(pdftotext -f "$first" -l "$last" -enc UTF-8 -nopgbrk "$pdf" - |
  LC_ALL=C.UTF-8 tr -s '[:space:]' ' ' | LC_ALL=C.UTF-8 wc -m)
echo "\\def\\upol@autochars{$chars}" > "$job.chars"
printf 'upol-count: pages %s-%s: %s characters (%s normostran)\n' \
  "$first" "$last" "$chars" "$(( chars / 1800 ))"
