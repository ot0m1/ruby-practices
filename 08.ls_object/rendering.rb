# frozen_string_literal: true

class Rendering
  def initialize
    @params = Parameter.new.params
    @file_collection = FileCollecter.new(@params)
  end

  def output
    puts @params['l'] ? render_long : render_short
  end

  private

  def render_short
    ajusted_files = @file_collection.ajustted_files

    if ajusted_files.length <= @file_collection.max_column_length
      ajusted_files.join(' ')
    else
      @file_collection.tabulate(ajusted_files)
    end
  end

  def render_long
    head = "total #{@file_collection.block_total}"
    body = @file_collection.make_long_format_body
    [head, *body].join("\n")
  end
end
