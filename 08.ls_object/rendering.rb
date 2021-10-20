# frozen_string_literal: true

class Rendering
  MAX_COLUMN_LENGTH = 3

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
    row_count = (ajusted_files.count.to_f / MAX_COLUMN_LENGTH).ceil
    transposed_files = safe_transpose(ajusted_files.each_slice(row_count).to_a)
    max_file_name_size = @file_collection.max_file_name_size

    transposed_files.map do |file|
      render_short_format_row(file, max_file_name_size)
    end.join("\n")
  end

  def render_long
    head = @file_collection.make_long_format_head
    body = @file_collection.make_long_format_body
    [head, *body].join("\n")
  end

  def safe_transpose(files)
    files[0].zip(*files[1..-1])
  end

  def render_short_format_row(files, max_file_path_count)
    files.map do |file|
      basename = file || ''
      basename.ljust(max_file_path_count + 1)
    end.join.rstrip
  end
end
