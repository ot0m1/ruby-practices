# frozen_string_literal: true

class FileCollecter
  attr_reader :files, :max_column_length

  MAX_COLUMN_LENGTH = 3

  def initialize(params)
    row_files = params['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    @files = params['r'] ? row_files.sort.reverse : row_files.sort
    @max_column_length = MAX_COLUMN_LENGTH
  end

  def ajusted_files
    adjust_to_max_file_name_size_count(files, max_file_name_size_count)
  end

  def tabulate(ajusted_files)
    row_count = (ajusted_files.count.to_f / max_column_length).ceil
    transposed_files = safe_transpose(ajusted_files.each_slice(row_count).to_a)
    format_table(transposed_files, max_file_name_size_count)
  end

  def make_long_format_body
    analysed_data = analyse_data
    max_sizes = %i[nlink user group size mtime].map do |key|
      find_max_size(analysed_data, key)
    end
    analysed_data.map do |data|
      format_row(data, max_sizes)
    end
  end

  def block_total
    analyse_data.sum { |data| data[:blocks] }
  end

  private

  def max_file_name_size_count
    files.map(&:size).max
  end

  def adjust_to_max_file_name_size_count(files, max_file_name_size_count)
    files.map do |file|
      file.ljust(max_file_name_size_count)
    end
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

  def analyse_data
    FileAnalyser.new(@files).analyse
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
