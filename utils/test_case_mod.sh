#!/bin/bash

walk_dir () {
    for pathname in "$1"/*; do
        if [ -d "$pathname" ]; then
            walk_dir "$pathname"
        else
            if [[ $pathname == *.scm ]]; then
		    echo "eof" >> $pathname;
	    fi
        fi
    done
}

TEST_CASE=/dir/to/your/original/scm/test/cases

walk_dir "$TEST_CASE"
