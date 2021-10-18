# frozen_string_literal: true

class FileAnalyser
  attr_reader :files

  def initialize(files)
    @files = files.map { |file| FileAndStat.new(file) }
  end

  def find_max_size(key)
    @files.map { |file| file.public_send(key).size }.max
  end

  def block_total
    @files.sum(&:blocks)
  end

  def format_row(file, max_sizes)
    [
      file.type_and_mode,
      "  #{file.nlink.rjust(max_sizes[0])}",
      " #{file.user.ljust(max_sizes[1])}",
      "  #{file.group.ljust(max_sizes[2])}",
      "  #{file.size.rjust(max_sizes[3])}",
      " #{file.mtime.rjust(max_sizes[4])}",
      " #{file.name}"
    ].join
  end
end
