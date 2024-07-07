#!/bin/sh -e
for file in test_*.sh; do
  if [ "$file" = "$0" ]; then continue; fi
  bash -e "$file" && echo "TEST $file SUCCESSFUL" >&2 || (echo "TEST $file FAILED" >&2 && exit 1)
done
echo "ALL TESTS SUCCEEDED" >&2
