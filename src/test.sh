#!/bin/bash
echo "kompile --backend java scheme.k -d ."
kompile --backend java scheme.k -d .

TestList="let cond io list fac define lambda"

for val in $TestList; do
  echo "Start testing tests/$val..."
  for f in $(find ../tests/$val/ -name "*.scm")
  do
    echo "--- testing $f"
    if [ $val == "io" ]; then
      cat $f.in 2>/dev/null | krun $f --output none  -d . | diff - $f.out
    else
      cat $f.in 2>/dev/null | krun $f --pattern "<k> V:K </k>" -d . | diff - $f.out
    fi
  done
  echo "Finish testing tests/$val!"
done

echo "All test cases passed!"
