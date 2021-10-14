# frozen_string_literal: true

class Game
  def initialize(frames)
    @frames = frames
  end

  def score
    (0..9).sum do |count|
      current_frame, next_frame, after_next_frame = @frames.slice(count, 3)
      next_frame ||= Frame.new(Shot.new(0))
      after_next_frame ||= Frame.new(Shot.new(0))

      if current_frame.strike?
        current_frame.sum + Frame.sum_next_first_two_shots(next_frame, after_next_frame)
      elsif current_frame.spare?
        current_frame.sum + next_frame.first_shot.numerate
      else
        current_frame.sum
      end
    end
  end
end
