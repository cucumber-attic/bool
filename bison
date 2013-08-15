#!/bin/bash
#
# Wrapper script that ensures we'll run the required version.
# If the required version is on the PATH, just use that.
# If not, download and build a local version and use that.
#
set -e
BASEDIR=$(cd `dirname $0` && /bin/pwd)
REQUIRED_BISON_VERSION=3.0
PATH=$BASEDIR/bison-$REQUIRED_BISON_VERSION/tests:$PATH
BISON_VERSION=`bison --version | grep ^bison | sed 's/^.* //'`

if [ "$REQUIRED_BISON_VERSION" != "$BISON_VERSION" ] ; then
  pushd $BASEDIR
    echo "****** DOWNLOADING bison-$REQUIRED_BISON_VERSION"
    curl --silent --location http://ftp.gnu.org/gnu/bison/bison-$REQUIRED_BISON_VERSION.tar.gz | tar xvz
    echo "****** BUILDING bison-$REQUIRED_BISON_VERSION"
    pushd bison-$REQUIRED_BISON_VERSION
      ./configure
      make
    popd
  popd
fi

bison $@

