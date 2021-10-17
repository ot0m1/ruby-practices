# frozen_string_literal: true

class FileAnalyser
  attr_reader :data

  def initialize(files)
    @files = files.map { |file| FileAndStat.new(file) }
    @data = @files.map { |file| build_data(file) }
  end

  def find_max_size(key)
    data.map { |datum| datum[key].size }.max
  end

  def block_total
    data.sum { |datum| datum[:blocks] }
  end

  def format_row(datum, max_sizes)
    [
      datum[:type_and_mode],
      "  #{datum[:nlink].rjust(max_sizes[0])}",
      " #{datum[:user].ljust(max_sizes[1])}",
      "  #{datum[:group].ljust(max_sizes[2])}",
      "  #{datum[:size].rjust(max_sizes[3])}",
      " #{datum[:mtime].rjust(max_sizes[4])}",
      " #{datum[:name]}"
    ].join
  end

  private

  def build_data(file)
    {
      type_and_mode: file.type_and_mode,
      nlink: file.nlink,
      user: file.user,
      group: file.group,
      size: file.size,
      mtime: file.long_format_date,
      name: file.name,
      blocks: file.blocks
    }
  end
end
