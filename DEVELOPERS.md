## Building for all platforms

If you're lucky and already have all the needed software installed you can just run

```
make
```

If that fails for you (it probably will the first time), don't worry. Follow the OS-specific instructions below and try again. 
If you still run into problems, see the relevant READMEs in the sub directories.

You are definitely going to need [GNU Bison](http://www.gnu.org/software/bison/) 2.7 or newer to build any platform library (except for the JavaScript library).

If you don't already have Bison 2.7 installed then the top level `Makefile` will install it into `./bison-2.7`.

### OS X

OS X ships with an old Bison we can't use. If you prefer to install Bison 2.7 with [Homebrew](http://mxcl.github.com/homebrew/) instead of under `./bison-2.7`,
then you must first install [Homebrew-Dupes](https://github.com/Homebrew/homebrew-dupes) 
before you can install Bison and the other requirements:

```
brew tap homebrew/dupes
brew install bison flex wget node
```

### Ubuntu

Ubuntu users can install the needed software with:

```
sudo apt-get install bison flex wget node mingw32
```

At the time of this writing, `apt-get` will install Bison 2.5, which is too old, so the `Makefile` will install `./bison-2.7` anyway.
When `apt-get` installs Bison 2.7 some day in the future this step will be skipped.

### Fedora

Fedora 18 can install the needed software with:

```
yum install bison flex wget node mingw32-gcc
```

## Making a release

Bump the version in `VERSION` and run `make version`. This updates the version in the package descriptors for all platforms.

