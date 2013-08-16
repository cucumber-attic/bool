## Ruby (MRI) on Linux/OS X

You need MRI 1.9.3-p327 or 2.0.0-p0 to build the native C code. OS X and Linux users can install this easily with [RVM](https://rvm.io/) or [rbenv](https://github.com/sstephenson/rbenv) + [ruby-build](https://github.com/sstephenson/ruby-build).
Do not use newer patch levels such as 1.9.3-p448, 2.0.0-p195 or 2.0.0-p247. They don't seem to install with clang. Not sure why.

Now you need to install dependencies. cd to this directory (`bool/ruby`) and run:

```
gem install bundler && bundle
```

This should install the gems listed in `bool.gemspec`. If you have already managed to build the C code you should be fine to
proceed and build the C extension. Just run

```
bundle exec rake
```

## Ruby (MRI) on Windows

To build windows gems we need to precompile the C extension using MinGW. For OS X the top level `Makefile` should download MinGW,
so all you need to do is to cd to the root directory and run:

```
make winruby
```

That should create a `.so` file under `lib`.

## JRuby 

First, install the latest JRuby with [RVM](https://rvm.io/) or [rbenv](https://github.com/sstephenson/rbenv/).

Second, we need to put a `jruby` executable your `PATH`:

```
mkdir ~/bin
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bash_profile
```

Third, create a `~/bin/jruby` script for either RVM or rbenv.

### RVM

RVM users can set up a `jruby` like so:

```
ln -s ~/.rvm/rubies/jruby-1.7.3/bin/jruby ~/bin/jruby
```

### rbenv

rbenv users can set up a `jruby` like so:

```
cp rbenv-jruby ~/bin/jruby
```

### Testing with jruby


The build should pass with:

```
jruby -S gem install bundler
jruby -S rake
```
