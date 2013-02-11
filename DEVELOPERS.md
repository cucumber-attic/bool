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
sudo apt-get install bison flex wget nodejs mingw32
```

At the time of this writing, `apt-get` will install Bison 2.5, which is too old, so the `Makefile` will install `./bison-2.7` anyway.
When `apt-get` installs Bison 2.7 some day in the future this step will be skipped.

### Fedora

Fedora 18 can install the needed software with:

```
yum install bison flex wget nodejs mingw32-gcc
```

## The Github Process

 The process for using git/github as we all start collaborating on bool and other Cucumber projects is similar to the [Github-Flow](http://scottchacon.com/2011/08/31/github-flow.html)

* **Anything** in the master branch is good enough to release
* Working on new features
    + Create a descriptively named branch off of master (ie: new-oauth2-scopes)
    + Commit to that branch locally and regularly
    + Push your work to the same named branch on the server
    + Regularly rebase this branch from master to keep it up to date.
* Open a pull request
    + When you need feedback or help
    + You think the branch is ready for merging (I do this using the [hub](https://github.com/defunkt/hub#git-pull-request) command-line tool -- @mattwynne)
* After someone else has reviewed and agreed on the change, you can merge it into master

 Here is an [Example](https://github.com/cucumber/bool/pull/12) of this process in action

### Tips for good commits

 1. Read up on [Github Flavored Markdown](https://help.github.com/articles/github-flavored-markdown)
      + especially links and syntax highlighting. GFM can be used in tickets as well as commit messages (e.g. put "#4" somewhere in a commit message to link ticket 4 to that commit.
 2. Close tickets with commits if you can.
     + Add "Closes #5, #9" somewhere in the commit message to both link and close. See [Issues 2.0 the Next Generation](https://github.com/blog/831-issues-2-0-the-next-generation) for details.
 3. Tag issues so we can do better triage and assignment.
     + People tend to gravitate towards areas of expertise and tags makes it easier to give a ticket to the right person.
 4. Update History.md
     + When you fix a bug or add a feature.
     + See gherkin's [History.md](https://github.com/cucumber/gherkin/blob/master/History.md) as a template.
     + Add release dates
 5.  Subscribe to ticket feeds so you stay in the loop and get a chance to provide feedback on tickets.
 6. The code standard is the existing code.
     + Use the same indentation, spacing, line ending and UTF-8 everywhere.
 7. Use git diff (or git diff --cached if you have staged) before every commit.
     + This helps you avoid committing changes you didn't mean to.
 8. Travis continously builds the master branch and any branch that starts with `ticket` or `fix`. See [.travis.yml](https://github.com/cucumber/bool/blob/master/.travis.yml)
 This is a good reminder for everyone to give branches descriptive names.

## Making a release

Bump the version in `VERSION` and run `make version`. This updates the version in the package descriptors for all platforms.
Commit all files and release all packages:

```
make release
```

### The first time you release

You need an account at:

* [rubygems.org](http://rubygems.org/)
* [npmjs.org](https://npmjs.org/)
* [oss.sonatype.org](https://oss.sonatype.org/)
  + [Sign up](http://issues.sonatype.org/) ([see docs](https://docs.sonatype.org/display/Repository/Sonatype+OSS+Maven+Repository+Usage+Guide)), in particular:
  + [Create](http://www.dewinter.com/gnupg_howto/english/GPGMiniHowto-3.html#ss3.1) and distribute your GPG public key to `hkp://pool.sks-keyservers.net/`:

    $ gpg list-public-keys
    $ gpg --keyserver hkp://pool.sks-keyservers.net/ --send-keys <YOUR PUBLIC KEY ID>

    + GPG Guide for [OS X](http://www.robertsosinski.com/2008/02/18/working-with-pgp-and-mac-os-x/)

Once all of your accounts are set up, create a Github ticket where you request release karma. 
Please specify user names at all accounts.

One of the existing release managers can now give you karma:

```
gem owner bool --add <RUBYGEMS-ORG-EMAIL>
npm owner add <NPM-JS-USER> bool
```

Karma to the `info.cukes` group in Sonatype must be given by someone from Sonatype - they don't let us administer our own group for some reason.

Once you have been given release karma you can try to make a release (just bump the minor version). If you have any questions,
ask in the original ticket you created. Once you can successfully release everything, confirm in the ticket and close it. 

At this point you can add your name below.

### Release managers

* Aslak Hellesøy
