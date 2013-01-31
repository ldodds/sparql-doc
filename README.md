# Generate HTML documentation from SPARQL queries

`sparql-doc` provides a simple tool for generating browsable HTML documentation 
from SPARQL queries.

This is particularly useful when preparing training materials or resources to 
help developers to use a particular dataset or SPARQL endpoint.

## SPARQL Documentation Extensions

`sparql-doc` processes your SPARQL queries and looks for comments. Like Javadoc, rdoc and 
similar tools, the content of the comments are used to provide metadata

All simple documentation lines at the start of a query will be treated as its description. E.g:

	#This is a description
	#of my query. It has multiple
	#lines
	DESCRIBE ?x 

Special tag can be used to specify other metadata, such as the title of a query:

	#This is a description
	#of my query. It has multiple
	#lines
	# @title My Query Title
	DESCRIBE ?x 

The full list of supported tags is:

* `@title`: should have a single value. Last title tag wins
* `@author`: author(s) of the query. Can have multiple uses
* `@see`: add a link from the documentation
* `@param`: parameter. Not yet used in template
* `@endpoint`: suggest an endpoint for using query. Automatically adds query link to docs
* `@tag`: add a tag to a query. Displayed but not yet used, but this will (eventually) be used to organise queries

Here's an example that uses all these:

	#This query illustrates how to describe a resource which is identified
	#by matching one of its properties. In this case a work is being identified
	#using its ISBN-10 value.
	# @title Describe via ISSN
	# @author Leigh Dodds
	# @see http://www.isbn.org/
	# @tag book
	# @tag isbn
	# @endpoint http://bnb.data.bl.uk/sparql 
	PREFIX bibo: <http://purl.org/ontology/bibo/> 
	DESCRIBE ?uri WHERE {
	  ?uri bibo:isbn10 "0261102214".
	}

The query description can be written in [Markdown](http://daringfireball.net/projects/markdown/). So 
you can include embedded markup, e.g. links, that help to further document a query.
 
## Example

Here's [the example output](http://ldodds.github.com/sparql-doc/) using the example queries included in the project.

## Installation

### Ruby Gem

Once RubyGems is out of read-only mode, I can release this as a gem until then use the manual instructions. 

### Manual Install

You'll need to make sure you have the following installed:

* Ruby 1.9.3
* RubyGems
* Rake

The code uses two gems which you'll need to have installed: JSON and [Redcarpet](https://github.com/vmg/redcarpet):

	[sudo] gem install json redcarpet

Once you have those installed, clone the repository and run the provided rake targets to build and install the gem 
locally:

	git clone https://github.com/ldodds/sparql-doc.git
	cd sparql-doc
	rake package
	rake install
	
Once installed you should have a `sparql-doc` command-line tool.

## Usage

_Note: the command-line syntax is likely to change in future. E.g. to add more options and/or other commands_

This takes two parameters:

* The input directory. The tool will process all `.rq` files in that directory
* The output directory. All HTML output and required assets will be placed here
	
E.g. you can run:

	sparql-doc examples/bnb /your/output/directory
	
This will generate documentation from the bundled examples and place it into the specified 
directory.

Later versions will support additional command-line options

## Roadmap

See the [issue list](https://github.com/ldodds/sparql-doc/issues). Got a suggestion? File an issue!

## License

This work is hereby released into the Public Domain.

To view a copy of the public domain dedication, visit http://creativecommons.org/licenses/publicdomain or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.