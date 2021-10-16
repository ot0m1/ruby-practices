# frozen_string_literal: true

class FileAnalyser
  def initialize(files)
    @files = files.map do |file|
      FileAndStat.new(file)
    end
  end

  def analyse
    @files.map do |file|
      build_data(file)
    end
  end

  private

  def build_data(file)
    {
      type_and_mode: file.type_and_mode,
      nlink: file.nlink,
      user: file.user,
      group: file.group,
      size: file.size,
      mtime: file.to_long_format_date,
      name: file.name,
      blocks: file.blocks
    }
  end
end
