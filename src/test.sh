#!/bin/bash
echo "kompile --backend java scheme.k -d ."
kompile --backend java scheme.k -d .

TestList="io"

for val in $TestList; do
    echo "Start testing tests/$val..."
    for f in $(find ../tests/$val/ -name "*.scm")
    do
        echo "--- testing $f"
        cat $f.in 2>/dev/null | krun $f --output none  -d . | diff - $f.out
    done
    echo "Finish testing tests/$val!"
done

echo "All test cases passed!"
