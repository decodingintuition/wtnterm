#!/usr/bin/env bash
set -e
src="$1"
pdf="${src%.tex}.pdf"

if ! command -v pdflatex >/dev/null 2>&1; then
	printf 'pdflatex is not installed or is not on PATH\n' >&2
	exit 1
fi

cat > "$src"
if output=$(pdflatex -interaction=nonstopmode -halt-on-error \
	-output-directory="$(dirname "$src")" "${@:2}" "$src" 2>&1); then
	printf '%s\n' "$pdf"
else
	printf '%s\n' "$output" >&2
	exit 1
fi
