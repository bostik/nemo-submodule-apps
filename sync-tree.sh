#!/bin/bash

# Handy reference, not actually used
MASTER_REPO_URI="git://github.com/nemomobile"

# We only need to list the names of the subdirectories here, since the
# actual repository details are in .gitmodules, and are used from there
# as needed.
SUBMODULE_REPOS="calculator calendar gallery mail maps"

# Set up the submodules.
# If there are new ones since last run, add them to locally known set
for item in ${SUBMODULE_REPOS}; do
    _name=${item##*:}
    # Only add new modules
    git config --get submodule.${_name} > /dev/null 2>&1
    if [ $? != 0 ]; then
        git submodule init ${_name}
    fi
done

# TODO: purge local tree for submodules that no longer exist


# Update the local repository config
git submodule sync


# Clone and checkout the submodule trees
git submodule update


# Qt has its own ideas how subdirs should have their project files
# named. Basically, a subdir 'foobar' needs to have 'foobar/foobar.pro'
# in it for qmake's automatic recursion to work.
for pfile in $(find . -mindepth 2 -maxdepth 2 -name '*.pro'); do
    _pro=${pfile##*/}
    _tmp=${pfile#*/}
    _dir=${_tmp%/*}
    if [ ! -e ${_dir}/${_dir}.pro ]; then
        # Create $SUBDIR.pro in the subdir
        (cd ${_dir} && ln -s ${_pro} ${_dir}.pro)
    fi
done

