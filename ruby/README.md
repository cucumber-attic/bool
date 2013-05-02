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

Before you can build the `ruby` module with JRuby you must ensure you can build the `java` module.
You also need `jruby` 1.7.3 on your `PATH`. How to achieve this depends on whether you are using
[RVM](https://rvm.io/) or [rbenv](https://github.com/sstephenson/rbenv/).

### RVM

RVM users can set up a `jruby` like so:

```
mkdir ~/bin
ln -s ~/.rvm/rubies/jruby-1.7.3/bin/jruby ~/bin/jruby
export PATH=$PATH:~/bin
```

The ruby build should now pass with:

```
jruby -S gem install bundler
jruby -S rake
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

Now make it executable:

```
chmod +x ~/bin/jruby
```

This will temporarily switch to using JRuby if the `jruby` command is used. Make sure that your `~/bin` directory is on your PATH and ahead of the rbenv shims directory.

The ruby build should now pass with:

```
jruby -S gem install bundler
jruby -S rake
```


