#!/bin/bash
# Note: This was run on Ubuntu 14.04.4 LTS
#
# Using the Imagemagick Debian repository (instead of the raw
# tarballs from the IM website https://www.imagemagick.org/download/releases/)
# because it also contains various patches made by debian maintainers
# and it's prepped for building.
#
# Git-related variables
GIT_REPO=https://anonscm.debian.org/git/collab-maint/imagemagick.git
GIT_BRANCHES=()
GIT_BRANCHES+=('remotes/origin/debian/6.7.7.9-1')
GIT_BRANCHES+=('remotes/origin/debian/6.7.7.9-2')
GIT_BRANCHES+=('remotes/origin/debian/6.7.8.10-1')
GIT_BRANCHES+=('remotes/origin/debian/6.7.8.2-1')
GIT_BRANCHES+=('remotes/origin/debian/6.7.9.3-1')
GIT_BRANCHES+=('remotes/origin/debian/6.7.9.3-2')
GIT_BRANCHES+=('remotes/origin/debian/6.8.0.10-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.0.2')
GIT_BRANCHES+=('remotes/origin/debian/6.8.0.7-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.1.0-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.1.5-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.3.10-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.3.6-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.3.7-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.3.9+svn11396-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.4.2-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.4.7-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.5.5-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.5.6-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.5.6-2')
GIT_BRANCHES+=('remotes/origin/debian/6.8.5.6-3')
GIT_BRANCHES+=('remotes/origin/debian/6.8.6.0-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.6.5-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.6.7-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.6.8-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.6.9-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.7.0-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.7.8-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.8.0-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.8.2-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.8.2-2')
GIT_BRANCHES+=('remotes/origin/debian/6.8.8.8-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.8.9-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.8.9-2')
GIT_BRANCHES+=('remotes/origin/debian/6.8.8.9-3')
GIT_BRANCHES+=('remotes/origin/debian/6.8.8.9-4')
GIT_BRANCHES+=('remotes/origin/debian/6.8.9.6-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.9.6-2')
GIT_BRANCHES+=('remotes/origin/debian/6.8.9.6-3')
GIT_BRANCHES+=('remotes/origin/debian/6.8.9.6-4')
GIT_BRANCHES+=('remotes/origin/debian/6.8.9.8-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.9.9-1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.9.9-2')
GIT_BRANCHES+=('remotes/origin/debian/6.8.9.9-3')
GIT_BRANCHES+=('remotes/origin/debian/6.8.9.9-4')
GIT_BRANCHES+=('remotes/origin/debian/6.8.9.9-5')
GIT_BRANCHES+=('remotes/origin/debian/6.8.9.9-5+deb8u1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.9.9-5.1')
GIT_BRANCHES+=('remotes/origin/debian/6.8.9.9-6')
GIT_BRANCHES+=('remotes/origin/debian/6.9.1.2-1')
GIT_BRANCHES+=('remotes/origin/debian/6.9.2.1-1')
GIT_BRANCHES+=('remotes/origin/debian/6.9.2.10+dfsg-1')
GIT_BRANCHES+=('remotes/origin/debian/6.9.2.10+dfsg-2')
GIT_BRANCHES+=('remotes/origin/debian/6.9.2.10+dfsg-3')
GIT_BRANCHES+=('remotes/origin/debian/6.9.2.10-1')
GIT_BRANCHES+=('remotes/origin/debian/6.9.2.2-1')
GIT_BRANCHES+=('remotes/origin/debian/6.9.2.3-1')

# Clone the debian repository
git clone $GIT_REPO imagemagick

# We're only interested in the identify binary so we aim
# at making a custom build for each branch. We're not
# building any documentation, we're also not going to let
# the IM build run any tests, we only want the binaries.
for BRANCH in "${GIT_BRANCHES[@]}"; do
    BRANCH_VER=$(echo "$BRANCH" | perl -ne 'm{(\d+(?:\.\d+)+.*)$} && print "$1"')
    IM_VER=../custom-build/im-$BRANCH_VER/
    pushd .
    cd imagemagick
    # remove any unversioned files created by the previous build
    git clean -dfx .
    # undo any changes to versioned files
    git reset --hard HEAD
    # checkout a new branch for the build
    git checkout $BRANCH
    # building a minimal imagemagick for testing purposes
    autoreconf -i
    ./configure --without-perl --without-magick-plus-plus --disable-docs --prefix="$PWD/$IM_VER"
    # speed up the build with 4 parallel jobs
    make -j4
    mkdir -p "$IM_VER"
    make install
    popd
done

