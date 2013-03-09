makemake
========

Framework to make self-contained webpages.

Place your files here:

    src/blah.haml
    src/blah.coffee
    static/blah.png

Give a list of downloads in downloads.yaml

    jquery.js: http://blah.com/jquery.js

Run rake:

    rake

And get your finished web page in build/blah.html

Run rake DEBUG=1 to not directly include the contents of the js/css files.
