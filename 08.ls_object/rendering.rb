# frozen_string_literal: true

class Rendering
  MAX_COLUMN_LENGTH = 3

  def initialize(params, files)
    @params = params
    @files = files
  end

  def output
    result = @params['l'] ? render_long : render_short
    puts result
  end

  private

  def render_short
    max_file_name_count = @files.map(&:size).max
    ajusted_files = adjust_to_max_file_name_count(@files, max_file_name_count)

    if ajusted_files.length <= MAX_COLUMN_LENGTH
      ajusted_files.join(' ')
    else
      tabulate(ajusted_files, max_file_name_count)
    end
  end

  def adjust_to_max_file_name_count(files, max_file_name_count)
    files.map do |file|
      file.ljust(max_file_name_count)
    end
  end

  def tabulate(files, max_file_name_count)
    row_count = (files.count.to_f / MAX_COLUMN_LENGTH).ceil
    transposed_files = safe_transpose(files.each_slice(row_count).to_a)
    format_table(transposed_files, max_file_name_count)
  end

  def safe_transpose(files)
    files[0].zip(*files[1..-1])
  end

  def format_table(files, max_file_name_count)
    files.map do |file|
      render_short_format_row(file, max_file_name_count)
    end.join("\n")
  end

  def render_short_format_row(files, max_file_path_count)
    files.map do |file|
      basename = file || ''
      basename.ljust(max_file_path_count + 1)
    end.join.rstrip
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
