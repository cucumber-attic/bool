#!/bin/bash
#
# Wrapper script that ensures we'll run the required version.
# If the required version is on the PATH, just use that.
# If not, download and build a local version and use that.
#
set -e
BASEDIR=$(cd `dirname $0` && /bin/pwd)
REQUIRED_FLEX_VERSION=2.5.37
PATH=$BASEDIR/flex-$REQUIRED_FLEX_VERSION:$PATH
FLEX_VERSION=`flex --version | cut -d' ' -f2`

if [ "$REQUIRED_FLEX_VERSION" != "$FLEX_VERSION" ] ; then
  pushd $BASEDIR
    echo "****** DOWNLOADING flex-$REQUIRED_FLEX_VERSION"
    curl --silent --location http://prdownloads.sourceforge.net/flex/flex-$REQUIRED_FLEX_VERSION.tar.gz?download | tar xvz
    echo "****** BUILDING flex-$REQUIRED_FLEX_VERSION"
    pushd flex-$REQUIRED_FLEX_VERSION
      ./configure
      make
    popd
  popd
fi

flex $@

