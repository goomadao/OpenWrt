#!/bin/bash
set -e

BUILD_JOB_NUMBER=`grep processor /proc/cpuinfo|wc -l`
DOWNLOAD_JOB_NUMBER=8

SHOULD_INITIALIZE=0
SHOULD_CLEAN=0
SHOULD_UPDATE=0

for arg in "$@"
do
    case $arg in
        -i|--initialize)
        SHOULD_INITIALIZE=1
        shift
        ;;
        -c|--clean)
        SHOULD_CLEAN=1
        shift
        ;;
        -u|--update)
        SHOULD_UPDATE=1
        shift
        ;;
        *)
        OTHER_ARGUMENTS+=("$1")
        shift
        ;;
    esac
done

initialize() {
    git submodule init
    git submodule update
    mkdir env
}

clean() {
    make distclean
}

update() {
    ./scripts/feeds update -a
    ./scripts/feeds install -a
}

if [[ $SHOULD_INITIALIZE == 1 ]]; then
    initialize
    update
fi

if [[ $SHOULD_CLEAN == 1 ]]; then
    clean
    update
fi

if [[ $SHOULD_UPDATE == 1 ]]; then
    update
fi

cp -f defconfig .config
cp -f kernel-config env/kernel-config
make defconfig
make -j$DOWNLOAD_JOB_NUMBER
make -j$BUILD_JOB_NUMBER
