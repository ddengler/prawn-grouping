require "prawn"
require "prawn/grouping/version"

module Prawn
  module Grouping

    # Groups a given block vertiacally within the current context, if possible.
    #
    # Parameters are:
    #
    # <tt>options</tt>:: A hash for grouping options.
    #     <tt>:too_tall</tt>:: A proc called before the content is rendered and
    #                          does not fit a single context.
    #     <tt>:fits_new_context</tt>:: A proc called before the content is
    #                                  rendered and does fit a single context.
    #     <tt>:fits_current_context</tt>:: A proc called before the content is
    #                                      rendered and does fit context.
    #
    def group(options = {}, &b)
      too_tall             = options[:too_tall]
      fits_new_context     = options[:fits_new_context]
      fits_current_context = options[:fits_current_context]

      # create a temporary document with current context and offset
      pdf = create_box_clone(y)
      pdf.exec(&b)

      if pdf.page_count > 1
        # create a temporary document without offset
        pdf = create_box_clone
        pdf.exec(&b)

        if pdf.page_count > 1
          # does not fit new context
          if too_tall
            exec(&too_tall)
          end
          yield self
        else
          if fits_new_context
            exec(&fits_new_context)
          end
          bounds.move_past_bottom
          yield self
        end
        false
      else
        # just render it
        if fits_current_context
          exec(&fits_current_context)
        end
        yield self
        true
      end
    end

    protected

    def exec(&block)
      if block.arity < 1
        instance_exec(&block)
      else
        block.call(self)
      end
    end

    private

    def create_box_clone(y = :keep)
      Prawn::Document.new(
        page_size: state.page.size, page_layout: state.page.layout,
        left_margin: bounds.absolute_left,
        top_margin: state.page.dimensions[-1] - bounds.absolute_top,
        right_margin: state.page.dimensions[-2] - bounds.absolute_right,
        bottom_margin: state.page.margins[:bottom]
      ) do |pdf|
        pdf.text_formatter = @text_formatter.dup
        pdf.font_families.update font_families
        pdf.font font.family
        pdf.font_size font_size
        pdf.default_leading = default_leading
        unless y == :keep
          pdf.y = y
        end
      end
    end
  end
end

Prawn::Document.extensions << Prawn::Grouping
