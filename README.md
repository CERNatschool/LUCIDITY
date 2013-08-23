CERN@school Hobo App Base
=========================

The CERN@school Hobo App Base is intended as a relatively straightforward
way to get started with a Hobo web app in the CERN@school style.
It takes many of the "out-of-the-box" features of a Hobo web app
and augments them to produce something that can be used for
rapid development with local prototyping, or a starting point
for an app using Amazon Web Services (AWS).

Further information:

* [Hobo homepage](https://hobocentral.net)
* [CERN@school homepage](https://cernatschool.org)
* [The Langton Star Centre](http://www.thelangtonstarcentre.org)

Requirements
------------

### Required software packages

You'll need `ImageMagick`, `node.js` and a few other bits to get
your Hobo web app up and running on your system:

    sudo apt-get install nodejs
    sudo apt-get install imagemagick
    sudo apt-get install libxslt-dev libxml2-dev

### Ruby, Rails and Hobo

You'll need Ruby and Rails to use the CERN@school web apps.
We recommend using [RVM](https://rvm.io) to manage your Ruby
installations.

    sudu apt-get install curl
    \curl -L https://get.rvm.io

After which, you'll probably want to add the following line to
your `.bashrc` file:

    source .rvm/scripts/rvm

Next, install Ruby and create a new gemset for your app:

    rvm install ruby-1.9.3-p392
    rvm use ruby-1.9.3-p392@APPNAME --create

Then install Rails and Hobo:

    gem install rails --version=3.2.14
    gem install hobo --version=2.0.1

And you should be ready to create a new repository for your web app.
