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

And get your finished web page in build/blah.html.

To get a single html page with all the resources inline, use

	rake package

haml tags:
----------

The custom haml tags used are as such:

	= include_js([js file path], [extra :key => val attributes])

to include either a src link to the javascript or the full file contents in package mode.

	= include_css([css file path], [extra :key => val attributes])

to include either a link tag for the javascript or the css file outright in (you'll never guess) package mode.

	= include_tag([tag name], [attr name for link], [extra :key => val attributes])

to do what you want.