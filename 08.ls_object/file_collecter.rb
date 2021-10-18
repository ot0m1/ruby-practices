# frozen_string_literal: true

class FileCollecter
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

  def make_long_format_body
    max_sizes = %i[nlink user group size mtime].map do |key|
      @analysed_files.find_max_size(key)
    end
    @analysed_files.files.map do |file|
      @analysed_files.format_row(file, max_sizes)
    end
  end

  def make_long_format_head
    "total #{@analysed_files.block_total}"
  end

  def max_file_name_size_count
    @files.map(&:size).max
  end
end
