#!/bin/bash
echo "kompile --backend java scheme.k -d ."
kompile --backend java scheme.k -d .

TestList="cond io list fac"

for val in $TestList; do
    if [ $val == "io" ]; then
        echo "Start testing tests/$val..."
        for f in $(find ../tests/$val/ -name "*.scm")
        do
            echo "--- testing $f"
            cat $f.in 2>/dev/null | krun $f --output none  -d . | diff - $f.out
        done
        echo "Finish testing tests/$val!"
    else
        echo "Start testing tests/$val..."
        for f in $(find ../tests/$val/ -name "*.scm")
        do
            echo "--- testing $f"
            cat $f.in 2>/dev/null | krun $f --pattern "<k> V:K </k>" -d . | diff - $f.out
        done
        echo "Finish testing tests/$val!"
    fi
done

echo "All test cases passed!"
