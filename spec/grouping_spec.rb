require File.join(File.expand_path(File.dirname(__FILE__)), "spec_helper")

describe "Prawn::Grouping" do
  it "returns true if the content fits in the current context" do
    pdf = Prawn::Document.new
    val = pdf.group do |pdf|
      pdf.text "FooBar"
    end
    expect(!!val).to eq(true)

    pages = PDF::Inspector::Page.analyze(pdf.render).pages
    expect(pages.size).to eq(1)
  end

  it "calls callbacks according to content length" do
    called = 0
    pdf = Prawn::Document.new do |pdf|
      pdf.group :fits_current_context => lambda { called = 1 } do |pdf|
        20.times { pdf.text "FooBar 1" }
      end
      expect(called).to eq(1)

      pdf.group :fits_new_context => lambda { called = 2 } do |pdf|
        40.times { pdf.text "FooBar 2" }
      end
      expect(called).to eq(2)

      pdf.group :too_tall => lambda { called = 3 } do |pdf|
        100.times { pdf.text "FooBar 3" }
      end
      expect(called).to eq(3)
    end
  end

  it "should allow nesting of groups" do
    pdf = Prawn::Document.new do
      5.times { text "1" }
      group do |pdf|
        10.times { pdf.text "1.1" }
      end
      group do |pdf|
        15.times { pdf.text "1.2" }
        pdf.group do |pdf|
          30.times { pdf.text "1.2.1" }
        end
      end
    end
    pages = PDF::Inspector::Page.analyze(pdf.render).pages
    expect(pages.size).to eq(2)
  end

  # the following example were copied to fit the original spec from
  # https://github.com/prawnpdf/prawn/blob/master/spec/document_spec.rb
  it "should group a simple block on a single page" do
    pdf = Prawn::Document.new do |pdf|
      pdf.y = 50
      val = pdf.group do |pdf|
        pdf.text "Hello"
        pdf.text "World"
      end

      # group should return a false value since a new page was started
      expect(!!val).to eq(false)
    end
    pages = PDF::Inspector::Page.analyze(pdf.render).pages
    expect(pages.size).to eq(2)
    expect(pages[0][:strings]).to eq([])
    expect(pages[1][:strings]).to eq(["Hello", "World"])
  end



  it "should group within individual column boxes" do
    pdf = Prawn::Document.new do
      # Set up columns with grouped blocks of 0..49. 0 to 49 is slightly short
      # of the height of one page / column, so each column should get its own
      # group (every column should start with zero).
      column_box([0, bounds.top], :width => bounds.width, :columns => 7) do
        10.times do
          group { |pdf| 50.times { |i| pdf.text(i.to_s) } }
        end
      end
    end

    # Second page should start with a 0 because it's a new group.
    pages = PDF::Inspector::Page.analyze(pdf.render).pages
    expect(pages.size).to eq(2)
    expect(pages[1][:strings].first).to eq('0')
  end

  it "should allow the use of inline formatting" do
    pdf = Prawn::Document.new do
      # Set up columns with grouped blocks of 0..49. 0 to 49 is slightly short
      # of the height of one page / column, so each column should get its own
      # group (every column should start with zero).
      group do |pdf|
        10.times { |i| pdf.text("<b>#{i}</b>", inline_format: true) }
      end
    end

    # Second page should start with a 0 because it's a new group.
    pages = PDF::Inspector::Page.analyze(pdf.render).pages
    expect(pages.size).to eq(1)
    expect(pages[0][:strings].first).to eq('0')

    pdf.render_file 'test.pdf'
  end

  it "should clone page margins from the original document" do
    outer_margins = nil
    inner_margins = nil

    Prawn::Document.new(margin: [0, 1, 2, 3]) do
      outer_margins = page.margins
      group do |pdf|
        inner_margins ||= pdf.page.margins
      end
    end

    expect(outer_margins).to_not be(inner_margins)
    expect(outer_margins).to eq(inner_margins)
  end
end
