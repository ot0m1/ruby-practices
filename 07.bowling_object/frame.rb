# frozen_string_literal: true

class Frame
  attr_reader :first_shot

  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
  end

  class << self
    def divide(shots)
      frame = []
      divided_shots = []

      shots.each do |shot|
        frame << shot
        if divided_shots.size < 10
          if frame.size >= 2 || shot.numerate == 10
            divided_shots << frame.dup
            frame.clear
          end
        else
          divided_shots.last << shot
        end
      end

      divided_shots
    end

    def sum_next_first_two_shots(frame, next_frame)
      summing_shots = frame.to_a << next_frame.first_shot
      summing_shots.compact.slice(0, 2).map(&:numerate).sum
    end
  end

  def to_a
    [first_shot, @second_shot, @third_shot]
  end

  def sum
    to_a.compact.map(&:numerate).sum
  end
end
