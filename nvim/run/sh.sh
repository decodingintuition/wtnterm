#!/usr/bin/env bash
set -e
out="$1"
{ printf '#!/usr/bin/env bash\n'; cat; } > "$out"
chmod +x "$out"
echo "$out"
