# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'
require_relative 'game'

puts Game.new(ARGV[0]).score
