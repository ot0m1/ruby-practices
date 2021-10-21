# frozen_string_literal: true

require 'date'
require 'etc'

class FileAndStat
  MODE_TABLE = {
    '0' => '---',
    '1' => '-x-',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(file)
    @file = file
    @stat = File.lstat(file)
  end

  def name
    @stat.symlink? ? "#{@file} -> #{File.readlink(@file)}" : @file
  end

  def type_and_mode
    "#{file_type}#{to_symbolic_notation}"
  end

  def nlink
    @stat.nlink.to_s
  end

  def mtime
    # Convert the last modified time to a string conforming to mac's ls
    now_date = Date.today
    last_update_date = @stat.mtime.to_date
    diff_month = now_date.year * 12 + now_date.month - last_update_date.year * 12 - last_update_date.month

    @stat.mtime.strftime("%-m %e #{diff_month >= 6 ? ' %-Y' : '%R'}")
  end

  def user
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size.to_s
  end

  def blocks
    @stat.blocks
  end

  def format_row(max_sizes)
    [
      type_and_mode,
      "  #{nlink.rjust(max_sizes[0])}",
      " #{user.ljust(max_sizes[1])}",
      "  #{group.ljust(max_sizes[2])}",
      "  #{size.rjust(max_sizes[3])}",
      " #{mtime.rjust(max_sizes[4])}",
      " #{name}"
    ].join
  end

  private

  def file_type
    if @stat.directory?
      'd'
    elsif @stat.symlink?
      'l'
    else
      '-'
    end
  end

  def to_symbolic_notation
    octal = @stat.mode.to_s(8)[-3, 3]

    octal.each_char.map do |str|
      MODE_TABLE[str]
    end.join
  end
end
