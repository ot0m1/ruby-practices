# frozen_string_literal: true

class LsFile < File
  def initialize(file)
    super
    @file = file
  end

  def name
    File.basename(@file)
  end
end
