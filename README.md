# Getting Started

This README will guide you through the process of setting up a development environment.

## Install Dependencies

### Install homebrew
```sh
ruby -e "$(curl -fsSLk https://gist.github.com/raw/323731/install_homebrew.rb)"
```

Detailed instructions can be found here: <http://mxcl.github.com/homebrew/>

### Install XCode
You must be a member of the Apple Developer program and the download is about 4GB.
<http://developer.apple.com/xcode/>

If you are using Lion, you can install XCode using the App Store.

### Install Git
```sh
brew install git
```

### Install PostgreSQL
```sh
brew install postgresql
```

**Make sure to follow the instructions after brew runs to install it or start it manually.**

Then create the superfit user by typing the following:

```sh
psql template1 -c 'create user superfit superuser';
```

### Install Redis

```
brew install redis
```

**Follow instructions after brew runs to startup redis.**

### Install RVM
```sh
bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
```

Detailed instructions can be found here: <http://rvm.beginrescueend.com/rvm/install/>

### Install Ruby 1.9.3 and set default version
```sh
rvm install 1.9.3
rvm use 1.9.3
rvm --default use 1.9.3
```

If you are running Lion and XCode 4.2+, you may need to run this command instead:

```sh
rvm install 1.9.3 --with-gcc=clang
```

You must restart your terminal session after installing RVM and Ruby.

### Setup GitHub
If you haven't already, setup your GitHub account and upload public keys. GitHub has a [Mac Setup Guide](http://help.github.com/mac-set-up-git/) to guide you through this.

### GitHub Privileges
Once you have a GitHub account setup, someone needs to give you access to the project. You can verify you have access by navigating to the [project page](https://github.com/mdebranski/superfit).

## Setup Project

Now that you have all of the dependencies installed, you will need to clone and setup the project.

### Clone project
Clone into your preferred project directory (e.g. ~/projects)

```sh
git clone git@github.com:mdebranski/superfit.git
```

### Ensure RVM is working
Change to the new project directory that you cloned into. RVM will prompt you to confirm that you trust the new .rvmrc file.  Check that rvm is working correctly by typing _rvm current_  It should print display _ruby-1.9.3-pXXX@superfit_

### Install bundler and needed gems
Run these in the project directory:

```sh
gem install bundler
bundle install
```

### Setup project database
Run rake task to create and seed the database:

```sh
rake setup
```

In the future, if you want to reset the database to its defaults:

```sh
rake resetup
```

## Start Server

Ensure the following are running:

1. PostgreSQL (for instructions on starting type _brew info postgresql_)
2. Redis (for instructions on starting type _brew info redis_)
3. Application (run _foreman start_)

You may also want to setup nginx as a reverse proxy in front of [unicorn for SSL](http://www.cyberciti.biz/faq/howto-linux-unix-setup-nginx-ssl-proxy/). (optional)

### Test It!
Navigate to <http://localhost:8080> to see if the app is working.

## Other Tools
Some other tools that I install: (optional)

-  hub - makes working with github easier (_brew install hub_)
-  [gitx](http://brotherbard.com/blog/2010/03/experimental-gitx-fork/) - graphical git client for Mac OS X (I alias the exec file to /usr/local/bin/gitx)
