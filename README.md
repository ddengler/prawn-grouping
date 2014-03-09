# Prawn::Grouping

[![Build Status](https://travis-ci.org/ddengler/prawn-grouping.png?branch=master)](https://travis-ci.org/ddengler/prawn-grouping)
[![Code Climate](https://codeclimate.com/github/ddengler/prawn-grouping.png)](https://codeclimate.com/github/ddengler/prawn-grouping)

An **experimental** gem to add a more flexible grouping option to the excellent prawn gem.

## Installation

Add this line to your application's Gemfile:

    gem 'prawn-grouping'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prawn-grouping

## Usage

### Grouping

```ruby
Prawn::Document.new do
  20.times { text "Regular text" }
  group do
    20.times { text "Paragraphs not separated unless neccessary" }
  end
end
```

### Nested Groups

```ruby
Prawn::Document.new do
  5.times { text "Regular text" }
  group do
    15.times { text "Paragraphs not separated unless neccessary" }
    group do
      30.times { text "Subparagraphs not separated unless neccessary" }
    end
  end
end
```

Do not overuse nesting because a every combination has to be tested recursively in a temporary document

### Options

Currently three callbacks are supported:

* `:fits_current_context` A proc called before the content is rendered and does fit context.
* `:fits_new_context` A proc called before the content is rendered and does fit a single context.
* `:too_tall` A proc called before the content is rendered and does not fit a single context.

```ruby
Prawn::Document.new do
  5.times { text "Regular text" }

  group :too_tall => lambda { start_new_page } do
    15.times { text "Paragraphs not separated unless neccessary" }
  end
end
```

The example above starts a new page if the content is too tall for a single page. Default behavior would be to just append the content.


## Troubleshooting

When using JRuby a block parameter has to be supplied. For the other tested Interpreters this is optional.

```ruby
Prawn::Document.new do
  5.times { text "Regular text" }

  group do |g|
    15.times { g.text "Paragraphs not separated unless neccessary" }
  end
end
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/prawn-grouping/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
