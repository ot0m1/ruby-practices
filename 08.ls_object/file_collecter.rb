# frozen_string_literal: true

class FileCollecter
  MAX_COLUMN_LENGTH = 3

  def initialize(params)
    row_files = params['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    @files = params['r'] ? row_files.sort.reverse : row_files.sort
    @analysed_files = FileAnalyser.new(@files) if params['l']
  end

  def ajustted_files
    @files.map do |file|
      file.ljust(max_file_name_size_count)
    end
  end

  def tabulate(ajusted_files)
    row_count = (ajusted_files.count.to_f / MAX_COLUMN_LENGTH).ceil
    transposed_files = safe_transpose(ajusted_files.each_slice(row_count).to_a)
    format_table(transposed_files, max_file_name_size_count)
  end

  def make_long_format_body
    max_sizes = %i[nlink user group size mtime].map do |key|
      @analysed_files.find_max_size(key)
    end
    @analysed_files.data.map do |datum|
      @analysed_files.format_row(datum, max_sizes)
    end
  end

  def make_long_format_head
    "total #{@analysed_files.block_total}"
  end

  private

  def max_file_name_size_count
    @files.map(&:size).max
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
end
