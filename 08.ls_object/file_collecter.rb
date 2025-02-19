# frozen_string_literal: true

class FileCollecter
  attr_reader :max_file_name_size

  def initialize(params)
    row_files = params['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    @files = params['r'] ? row_files.sort.reverse : row_files.sort
    @max_file_name_size = max_file_name_size_count
    @analysed_files = FileAnalyser.new(@files) if params['l']
  end

  def ajustted_files
    @files.map do |file|
      file.ljust(@max_file_name_size)
    end
  end

  def make_long_format_body
    max_sizes = @analysed_files.max_sizes
    @analysed_files.files.map do |file|
      file.format_row(max_sizes)
    end
  end

  def make_long_format_head
    "total #{@analysed_files.block_total}"
  end

  private

  def max_file_name_size_count
    @files.map(&:size).max
  end
end
