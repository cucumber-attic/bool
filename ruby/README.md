## Ruby (MRI)

You need MRI 1.9.3 or newer.

Now you need to install dependencies:

```
gem install bundler && bundle
```

If you have already managed to build the C code you should be fine. Just run

```
rake
```

## JRuby 

You need JRuby 1.7.2 or newer.

If you have already managed to build the Java code you should be fine. You also need `jruby` on your `PATH`. RVM users can do this like so:

```
ln -s ~/.rvm/rubies/jruby-1.7.2/bin/jruby ~/bin/jruby
export PATH=$PATH:~/bin
```

Now just run

```
rake
```
