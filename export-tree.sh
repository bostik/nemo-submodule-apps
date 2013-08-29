#!/bin/bash

OUTDIR=/tmp

if [ "x$1" != "x" ]; then
    _dir=$1
    if [ -d ${_dir} ]; then
        OUTDIR=$1
    fi
fi

PFX=$(basename $(dirname $(readlink -f $0)))


# List of all files in the whole tree.
# NOTE: The variable '$path' is exported by git-ls-tree, and it must be
# expanded INSIDE the command executed for submodule-foreach; hence the
# single quotes around the command.
{ \
    git ls-files; \
    git submodule foreach --recursive --quiet \
        'git ls-files | sed s,^,$path/,' ;
} | sed s,^,${PFX}/, \
| xargs tar -J -c -C .. -f "${OUTDIR}/${PFX}.tar.xz" --

