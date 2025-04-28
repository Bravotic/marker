# Marker

Marker is a domain specific language designed to make managing collections of
links easier. When a Marker document is compiled, it compiles to data easily
used by the Racket programming language. This allows Marker documents to
essentially act as code. The following is an example of Marker's document
format:

```scheme
("Marker Github" "https://github.com/bravotic/marker")
("Marker Webpage" "https://bravotic.com/marker")
["Racket"
  ("Racket Website" "https://racket-lang.org")
  ("Racket Docs" "https://docs.racket-lang.org")]
```

From this document, Marker can be compiled into the following formats:

* HTML
* Firefox/Chrome Bookmarks
* Plain Text

as well as many more yet to come!

Don't see a format you want to use here? Not to worry! Thanks to Racket, all you
need to do to make your own format generator is simply tell Marker how you want
a bookmark or folder to look. No need to worry about parsing and reading, Marker
will take care of all of that for you!

## Install

To install Marker, simply run the command `raco pkg install marker` or use the
DrRacket package manager. This will install the latest stable version of
Marker.

If for some reason you need to install the most bleeding edge version of Marker,
simply clone the repo and run:
`raco pkg install --link marker/ marker-lib/ marker-generators/`

## Development

Marker is split into two main parts, the generators and the core language. These
parts are also split in this repo.

The core language refers to anything which happens when a Marker file is read
and processed into Racket. Anything which happens in this stage can be found in
the `marker-lib` subpackage. If you are developing on top of Marker, this should
be the only package you need to install.

The generators refer to anything which takes Marker data and turns it into a new
format. The html, text, and bookmarks generators fall into this category. The
implementations of these generators can be found in the `marker-generators`
subpackage.