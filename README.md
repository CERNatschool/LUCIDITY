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

### Software packages

You'll need `mysql`, `ImageMagick`, `node.js` and a few other bits to get
your Hobo web app up and running on your system:

    sudo apt-get install mysql-server
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

Creating and installing the Development version
-----------------------------------------------

### Creating a new GitHub repo for your app

Since we're copying a "base" app, we'll need to duplicate the original
repo into a fresh one. Working in a suitable directory, perform the
following steps:

    mkdir tmp
    cd tmp
    git clone --bare https://github.com/CERNatschool/CERNatschool-HoboAppBase.git
    cd CERNatschool-HoboAppBase.git/

Next, create a blank repo on your [GitHub](https://github.com) site.
This will be where your new app will be hosted.
Let's suppose you give it the name `APPNAME`. You now push the base app
into the new repo you've just created:

    git push --mirror https://github.com/CERNatschool/APPNAME.git

You'll need to supply the necessary GitHub credentials, of course.

Tidy up:

    cd ../
    rm -rf CERNatschool-HoboAppBase.git/
    cd ../
    rm -rf tmp/

And, finally, clone the new repo as you normally would:

    git clone https://github.com/CERNatschool/APPNAME.git
    cd APPNAME

You now have the base app cloned from its new GitHub repo.


### Setting up the app for local deployment (development)

The CERN@school Hobo app base comes pretty much ready for local
deployment (that's kind of the point). There are a few things
you'll need to do to get it ready to run, though.

First, run the `setup.py` script to prepare the sensitive
file templates and insert your chosen `APPNAME` where necessary:

    python setup.py --app-name="APPNAME" --db-suffix="DBSUFFIX"

where `DBSUFFIX` is a short suffix to be appended to
the database names defined in `config/database.yml`.

Then install the gems required by the app:

    bundle install

Now for the database. If it doesn't exist already, you'll need to create
a `mysql` user for your Hobo app:

    mysql -u root -p # and enter your root password

```mysql
CREATE USER 'local_dev'@'localhost' IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON *.* TO 'local_dev'@'localhost';
QUIT;
```

You can then log back in to `mysql` and create the database for your app:

    mysql -u local_dev -p # No password required...

```mysql
CREATE DATABASE local_dev_db_DBSUFFIX;
QUIT;
```

All going to plan, you should be able to migrate the database:

    rake db:migrate

Finally, fill in the `development` section of the email configuration
file `config/email.yml`. For example, to use a
[gmail](https://gmail.com) account, use something like the following settings:

```yml
development:
  host: "localhost:3000"
  from: [Gmail address]
  #
  address: "smtp.gmail.com"
  port: 587
  user_name: [Gmail address, also your username]
  password: [Password]
  domain: [Your domain - doesn't seem to matter too much...]
  authentication: "plain"
  enable_starttls_auto: true
```

The `.gitignore` file is configured to ignore this file, so
don't worry (too much) about accidentally committing this information
to GitHub.

Finally, don't forget to update the `README.md` file to provide
some basic instructions for users and developers of your app.

    vim README.md

And that's it! You should be ready to run the app.

### Running the local development version of your app

If everything has worked so far, it should be as simple as:

    rails s

and then visiting [http://localhost:3000](http://localhost:3000) on your
browser. This should take you to the default adminsitrator account creation
page. You should complete this as usual. Note that if you've entered
correct details into `config/email.yml`, you should be able to
invite new users (for test purposes only, of course - anyone you invite
would have to have access to your local machine!).
