# Prawn::Grouping

[![Gem Version](https://badge.fury.io/rb/prawn-grouping.png)](http://badge.fury.io/rb/prawn-grouping)
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
  group do |g|
    20.times { g.text "Paragraphs not separated unless necessary" }
  end
end
```

### Nested Groups

```ruby
Prawn::Document.new do
  5.times { text "Regular text" }
  group do |g|
    15.times { g.text "Paragraphs not separated unless necessary" }
    group do |g|
      30.times { g.text "Subparagraphs not separated unless necessary" }
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

  group :too_tall => lambda { start_new_page } do |g|
    15.times { g.text "Paragraphs not separated unless necessary" }
  end
end
```

The example above starts a new page if the content is too tall for a single page. Default behavior would be to just append the content.


## Troubleshooting

#### Manipulating objects within the group block

The grouping internally works by executing the block one or _multiple_ times and checking the results, because deep copy did not work well for the original implementation in many cases. As a result you should not manipulate your data objects within the block. See issue #7 for details.

#### Elements render twice

This probably happens because you reference the original document within your group by using pdf.text in the curly braces. The following should also work:

```ruby
Prawn::Document.new do |pdf|
    pdf.group do |group_pdf|
        40.times { group_pdf.text "1111" }
    end

    pdf.group do  |group_pdf|
        40.times { group_pdf.text "222" }
    end
end
```ruby

## Contributing

1. Fork it ( http://github.com/<my-github-username>/prawn-grouping/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
