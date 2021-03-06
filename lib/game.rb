# frozen_string_literal: true

class Game
  attr_reader :frames

  def initialize(frame_class: Frame, bowl_class: Bowl)
    @bowl_class = bowl_class
    @frame_class = frame_class
    @frames = []
    @current = {
      frame: 1,
      bowl: 1
    }
  end

  # Note - can we refactor this to take out if/else and reduce the no of lines?
  def add_bowl(pins:)
    if @current[:bowl] == 1
      create_new_frame(pins)
    else
      add_bowl_to_current_frame(pins)
    end
  end

  def state
    puts "Current Frame: #{@current[:frame]}; Current Bowl: #{@current[:bowl]}"
  end

  private

  def create_new_bowl(pins)
    @bowl_class.new(pins: pins)
  end

  def create_new_frame(pins)
    error_checks(pins)
    bowl = create_new_bowl(pins)
    frame = @frame_class.new(number: @current[:frame])
    frame.add(bowl: bowl)
    @frames.push(frame)
    check_for_strike(pins)    
  end

  def add_bowl_to_current_frame(pins)
    error_checks(pins)
    bowl = create_new_bowl(pins)
    @frames.last.add(bowl: bowl)
    @current[:frame] += 1
    @current[:bowl] -= 1
  end

  def check_for_strike(pins)
    if pins == 10
      @current[:frame] += 1 
    else
      @current[:bowl] += 1
    end
  end

  def error_checks(pins)
    invalid_pins(pins)
    invalid_total(pins) if @current[:bowl] == 2
  end

  def invalid_pins(pins)
    raise('Your score must be between 0 and 10') if (pins < 0) or (pins > 10)
  end

  def invalid_total(pins)
    raise('Your total score for the frame cannot exceed 10; please check your scores') if (@frames.last.pins + pins) > 10
  end
end