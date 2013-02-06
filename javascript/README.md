## JavaScript

You need `node`, `npm` and `make` on your `PATH`. Now just run

```
make
```


## Ubuntu installation

You need node v0.8.11 or higher and the default node package in Ubuntu 12.04 is v0.6.12

So you would need to do the following additional steps:

---
sudo add-apt-repository ppa:richarvey/node.js
sudo apt-get update
sudo apt-get install nodejs npm
---

And after the installation make sure that you have bundler installed:

---
gem install bundler
bundle make
bundle exec rake
---
