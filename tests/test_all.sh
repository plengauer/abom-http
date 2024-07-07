#!/bin/sh -e
for file in test_*.sh; do
  if [ "$file" = "$0" ]; then continue; fi
  bash -e "$file" || failed=1
  if [ "$failed" = 1 ]; then
    echo "TEST $file FAILED" >&2
    exit 1
  fi
  echo "TEST $file SUCCESSFUL" >&2
done
echo "ALL TESTS SUCCEEDED" >&2
