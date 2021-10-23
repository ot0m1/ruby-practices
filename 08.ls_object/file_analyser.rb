# frozen_string_literal: true

class FileAnalyser
  attr_reader :files

  def initialize(files)
    @files = files.map { |file| FileAndStat.new(file) }
  end

  def block_total
    @files.sum(&:blocks)
  end

  def max_sizes
    %i[nlink user group size mtime].map do |key|
      find_max_size(key)
    end
  end

  private

  def find_max_size(key)
    @files.map { |file| file.public_send(key).size }.max
  end
end
