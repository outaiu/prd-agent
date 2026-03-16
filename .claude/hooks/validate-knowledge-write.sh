#!/usr/bin/env bash
set -euo pipefail

# stdin から PostToolUse の JSON を読む
INPUT=$(cat)

# ファイルパスを取得
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
# Write tool の場合
inp = data.get('tool_input', {})
print(inp.get('file_path', inp.get('path', '')))
" 2>/dev/null || echo "")

# knowledge/ 配下のYAMLファイルのみ対象
if [[ "$FILE_PATH" == *"knowledge/"* && "$FILE_PATH" == *".yaml" ]]; then
  # YAML構文チェック
  if ! python3 -c "
import yaml, sys
with open('$FILE_PATH') as f:
    yaml.safe_load(f)
" 2>/dev/null; then
    echo "WARNING: $FILE_PATH is not valid YAML. Please fix." >&2
  fi

  # updated_at フィールドの存在チェック
  if ! grep -q "updated_at:" "$FILE_PATH" 2>/dev/null; then
    echo "WARNING: $FILE_PATH is missing 'updated_at' field." >&2
  fi
fi

exit 0
