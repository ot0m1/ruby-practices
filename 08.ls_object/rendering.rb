# frozen_string_literal: true

class Rendering
  def initialize
    @params = Parameter.new.params
    @file_collection = FileCollecter.new(@params)
    @files = @file_collection.files
  end

  def output
    puts @params['l'] ? render_long : render_short
  end

  private

  def render_short
    ajusted_files = @file_collection.ajusted_files

    if ajusted_files.length <= @file_collection.max_column_length
      ajusted_files.join(' ')
    else
      @file_collection.tabulate(ajusted_files)
    end
  end

  def render_long
    analysed_data = FileAnalyser.new(@files).analyse
    block_total = analysed_data.sum { |data| data[:blocks] }
    head = "total #{block_total}"
    body = make_long_format_body(analysed_data)
    [head, *body].join("\n")
  end

  def make_long_format_body(analysed_data)
    max_sizes = %i[nlink user group size mtime].map do |key|
      find_max_size(analysed_data, key)
    end
    analysed_data.map do |data|
      format_row(data, max_sizes)
    end
  end

  def find_max_size(analysed_data, key)
    analysed_data.map { |data| data[key].size }.max
  end

  def format_row(data, max_sizes)
    [
      data[:type_and_mode],
      "  #{data[:nlink].rjust(max_sizes[0])}",
      " #{data[:user].ljust(max_sizes[1])}",
      "  #{data[:group].ljust(max_sizes[2])}",
      "  #{data[:size].rjust(max_sizes[3])}",
      " #{data[:mtime].rjust(max_sizes[4])}",
      " #{data[:name]}"
    ].join
  end
end
