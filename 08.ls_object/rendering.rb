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
    @file_collection.tabulate(ajusted_files)
  end

  def render_long
    head = @file_collection.make_long_format_head
    body = @file_collection.make_long_format_body
    [head, *body].join("\n")
  end
end
