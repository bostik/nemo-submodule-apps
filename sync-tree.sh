#!/bin/bash

# Handy reference, not actually used
MASTER_REPO_URI="git://github.com/nemomobile"

# We only need to list the names of the subdirectories here, since the
# actual repository details are in .gitmodules, and are used from there
# as needed.
SUBMODULE_REPOS="calculator calendar gallery mail"

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


