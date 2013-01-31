## Ruby (MRI)

If you have already managed to build the C code you should be fine. Just run

```
rake
```

## JRuby 

If you have already managed to build the Java code you should be fine. You also need `jruby` on your `PATH`. RVM users can do this like so:

```
ln -s ~/.rvm/rubies/jruby-1.7.2/bin/jruby ~/bin/jruby
export PATH=$PATH:~/bin
```

Now just run

```
rake
```
