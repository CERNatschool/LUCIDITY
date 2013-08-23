#!/usr/bin/env python

"""
Setup script for Hobo web app deployment.
"""

import os, inspect
import sys, getopt
import fileinput

cpth=os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))

def write_email_cfg(f):
    f.write('  host: ""'                      + os.linesep)
    f.write('  from: ""'                      + os.linesep)
    f.write('  #'                             + os.linesep)
    f.write('  address: ""'                   + os.linesep)
    f.write('  port:'                         + os.linesep)
    f.write('  user_name: ""'                 + os.linesep)
    f.write('  password: ""'                  + os.linesep)
    f.write('  domain: ""'                    + os.linesep)
    f.write('  authentication: ""'            + os.linesep)
    f.write('  enable_starttls_auto: '        + os.linesep)

if __name__ == '__main__':

    appname  = "BASENAME"
    dbsuffix = "DBSUFFIX"
    # Parse arguments
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hn:d:", \
                                   ["help","app-name=","db-suffix="])
    except getopt.GetoptError:
        print("setup.py -n <app name> -d <database suffix>")
        sys.exit(2)

    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print("Sets up the Hobo web app files.")
            print("USAGE:")
            print("$ setup.py -n <app name> -d <database suffix>")
            sys.exit()
        elif opt in ("-n", "--app-name"):
            appname = arg
        elif opt in ("-d", "--db-suffix"):
            dbsuffix = arg

    print(" * Application name is '%s'" % (appname))
    print(" * Database suffix is '%s'"  % (dbsuffix))

    # Change the database names
    for line in fileinput.input("config/database.yml", inplace = 1):
        print line.replace("DBSUFFIX", dbsuffix),

    # Replace the app name in the .dryml files.
    for line in fileinput.input("app/views/taglibs/application.dryml", inplace=1):
        print line.replace("APPNAME", appname),
    #
    for line in fileinput.input("app/views/taglibs/front_site.dryml", inplace=1):
        print line.replace("APPNAME", appname),


    email_yml_file     = open(os.path.join(cpth, 'config/email.yml'),     'w')
    amazon_yml_file    = open(os.path.join(cpth, 'config/amazon.yml'),    'w')
    amazon_s3_yml_file = open(os.path.join(cpth, 'config/amazon_s3.yml'), 'w')

    # The email configuration file.
    email_yml_file.write('production:' + os.linesep)
    write_email_cfg(email_yml_file)
    email_yml_file.write(os.linesep)
    email_yml_file.write('development:' + os.linesep)
    write_email_cfg(email_yml_file)

    # The AWS configuration file (for production)
    amazon_yml_file.write('access_key_id:'     + os.linesep)
    amazon_yml_file.write('secret_access_key:' + os.linesep)

    # The AWS S3 configuration file (for production)
    amazon_s3_yml_file.write('production:' + os.linesep)
    amazon_s3_yml_file.write('  bucket:'   + os.linesep)

    email_yml_file.close()
    amazon_yml_file.close()
    amazon_s3_yml_file.close()
