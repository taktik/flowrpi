#!/usr/bin/env sh
if [ -n "$BASH_SOURCE" ]; then
    THIS_SCRIPT=$BASH_SOURCE
elif [ -n "$ZSH_NAME" ]; then
    THIS_SCRIPT=$0
else
    THIS_SCRIPT="$(pwd)/setup.sh"
fi

if [ -z "$ZSH_NAME" ] && [ "$0" = "$THIS_SCRIPT" ]; then
    echo "Error: This script needs to be sourced. Please run as '. $THIS_SCRIPT'"
    exit 1
fi

TOPDIR=${PWD}
export PATH=${TOPDIR}/sources/base/tools:${PATH}
. ./sources/poky/oe-init-build-env

# remove duplicate entries from path
# export PATH=`echo $PATH_ | awk -F: '{for (i=1;i<=NF;i++) { if ( !x[$i]++ ) printf("%s:",$i); }}'`
export PATH=$(awk -F: '{for(i=1;i<=NF;i++){if(!($i in a)){a[$i];printf s$i;s=":"}}}' <<<$PATH)

# Setup layers
# Now plug-in local customizations
if [ ! -e conf/auto.conf ]; then
    bitbake-layers add-layer ../sources/meta-openembedded/meta-oe
    bitbake-layers add-layer ../sources/meta-openembedded/meta-multimedia
    bitbake-layers add-layer ../sources/meta-openembedded/meta-python
    bitbake-layers add-layer ../sources/meta-openembedded/meta-networking
    bitbake-layers add-layer ../sources/meta-wpe
    bitbake-layers add-layer ../sources/meta-96boards
    bitbake-layers add-layer ../sources/meta-raspberrypi

    (cd conf && ln -sf ../../sources/base/auto.conf .)
fi

echo "Build Environment is ready  for `cat conf/auto.conf | grep 'MACHINE='`"
echo "To build image run"
echo "--------------------------"
echo "bitbake wpe-eglfs-image"
echo "--------------------------"
