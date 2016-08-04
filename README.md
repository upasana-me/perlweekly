###Status
[![Build Status](https://travis-ci.org/szabgab/perlweekly.png)](https://travis-ci.org/szabgab/perlweekly)

Website of the Perl Weekly newsletter

http://perlweekly.com/

The source format
==================

Each edition of the Perl Weekly is in a JSON file in the src/ directory.
There is a skeleton called src/next.json. The chapter (section) titles are there
to help but can be reordered/removed/replaced.

The main part of the JSON has the following fields

```
"date" : "2016-08-08",  # The publish date of the edition.
"editor" : "",          # A key from the src/authors.json file.
"subject" : "",         # The main subject line of the email.
"header" : [            # The top text of the edition. Your 'editorial' comments.
   "Bla...",
   "More bla..."
],
"footer" : [            # The same at the end of the edition. Usually unused.
],
"chapters" : [          # The sections of the newsletter.
    ...
]
```

Each section (chapter) has the following fields:

```
"title" : "",     # Short title
"sponsor" : 1,    # only used in the Sponsors section to make it stand out
"header" : "",    # of the section. Rarely used.
"footer" : "",    # at the bottom of each section. Rarely used.
"entries" : [     # One entry per article we share.
]
```

Each entry has the following fields:

```
"title" : "",        # The title of the entry (usually the title original of the article)
"author" : "",       # One of the keys from the src/authors.json file
"text" : "",         # Whatever is our longer description of the article
                     # Extra links can be added as <a href=\"http://..\">...</a>
"url" : "",          # The real URL of the article
"ts" : "2016.08.01", # The date of the article
"tags" : []          # List of keywords. (Unfortunately not in use)

"link" : ""          # Was used for a shortened bitly url, but it is currently not in use.
```

The 'editorial' process
========================


Gabor:
-----

I follow a bunch of RSS/Atom feeds of blogs. Look at some other resource such as http://blogs.perl.org  http://www.reddit.com/r/perl and probably a few others. I am subscribed to "perl" on Google Alerts. Sometimes people send me e-mails.

When I want to start preparing the next edition (and this can happen the day after the previous edition, or if I am too busy, then the day before the next edition is due) I copy  src/next.json to the appropriate src/###.json and manually update it.

I update the 'title', 'text', 'url', 'author', and 'ts' fields. I have not touched the 'tags' for quite some time, though it would be nice to use that too and then display the values. At least on the web site.

Yanick:
-------

I first create a 'week-123' branch (where "123" is the current week number,
natch). Then I copy my Markdown template in the src/ directory

    cp template.mkd src/123.mkd
 
I keep all the feeds that I usually peruse in data/feeds.url, and I have a
script that visit them all and auto-generate entries for anything that
appeared in the last week

    perl bin/gen_mkd_from_feeds.pl data/feeds.url >> src/123.mkd

I then edit src/123.mkd manually. Add anything else I saw elsewhere,
put the entries in the appropriate section (sections that don't
have entries will be automatically removed, and entries will also
be chronologically sorted in the next step).

Then I convert the markdown in json

    perl bin/mkd2json.pl src/123.mkd

Check that all looks good

    perl bin/generate.pl web 123
    firefox html/archive/123.html

Finally, I commit src/123.json and send a pull request to Gabor.


The final touch
-----------------

This is done (and partially skipped) by Gabor before sending out the newsletter. Don't worry about it.

* Run `bin/tidy_json.pl` to make the source JSON files unified.
* Update src/next.json to have the next date (this is used on the front page)
* Update src/count.txt from http://mail.perlweekly.com/mailman/admin/perlweekly/members
* add sponsors, if there are any
* Update the ```src/events.json``` by runnig ```bin/perl-events.pl``` and maybe by moving some old items to ```src/old_events.json```
* Copy the section of events from the previous edition, and update it (remove old, add new)
* Add authors where they are missing.
* Run ispell on the source file and try not to "fix" British English with American English
* Run  bin/bitly.pl to add the bitly links
* Run bin/generate.pl web all
* I commit, push
* Then run my own 'up.pl' script that will ssh to the production server and pull this repository from github.
* Look at the web page. If things need to be fixed, I go back to one of the previous steps.
* Once I am satisfied I ssh to the perlweekly.com server.
* run perl bin/sendmail.pl --issue --to my@email.address
* look at the received e-mail to see if it looks ok.
* If it does, run the sendmail script again but this time to the address of the perlweekly.com mailing list.
* If I don't make a typo there, then Mailman soon sends me two e-mails. One because I sent an e-mail
  that was held for approval and the other one as I am the list administrator. I follow the link in this
  second e-mail and approve the message to go out to the mailing list.

* Then I go and paste the link of the latest editon in the Perl Developers group on Facebook, the Perl Weekly page on Google+,
  LinkedIN, Twitter.


