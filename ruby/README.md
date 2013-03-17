## Ruby (MRI) on Linux/OS X

You need MRI 1.9.3 or newer. OS X and Linux users can install this easily with [RVM](https://rvm.io/).

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

You need JRuby 1.7.2 or newer. OS X and Linux users can install this easily with [RVM](https://rvm.io/).

If you have already managed to build the Java code you should be fine. You also need `jruby` on your `PATH`. RVM users can do this like so:

```
mkdir ~/bin
ln -s ~/.rvm/rubies/jruby-1.7.2/bin/jruby ~/bin/jruby
export PATH=$PATH:~/bin
jruby -S gem install bundler --pre
```

Now just run

```
rake
```

### rbenv with JRuby

If you are using rbenv to build the JRuby tests, you might get a message like this:

```
rbenv: jruby: command not found

The `jruby' command exists in these Ruby versions:
  jruby-1.7.3
```

This is because the `jruby` wrapper in the  doesn't exist on the path for the default version of ruby you are using. One possible workaround is to add your own `jruby` shell wrapper to your own `~/bin` directory, containing the following:

```
#!/bin/sh

RBENV_VERSION=`rbenv versions | grep jruby | tail -1 | perl -pe 's/^.*(jruby-[^\s]+).*$/$1/'` ~/.rbenv/shims/jruby "$@"
```

This will temporarily switch to using JRuby if the `jruby` command is used. Make sure that your `~/bin` directory is ahead of the rbenv shims directory.
