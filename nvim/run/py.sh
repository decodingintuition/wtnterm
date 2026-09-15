#!/usr/bin/env bash
set -e
out="$1"
{ printf '#!/usr/bin/env python3\n'; cat; } > "$out"
chmod +x "$out"
echo "$out"
