# frozen_string_literal: true

require_relative 'parameter'
require_relative 'file_collecter'
require_relative 'file_analyser'
require_relative 'file_and_stat'
require_relative 'rendering'

Rendering.new.output
