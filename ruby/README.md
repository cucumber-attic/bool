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
ln -s ~/.rvm/rubies/jruby-1.7.2/bin/jruby ~/bin/jruby
export PATH=$PATH:~/bin
```

Now just run

```
rake
```
