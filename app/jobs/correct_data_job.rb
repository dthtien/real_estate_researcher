class CorrectDataJob < ApplicationJob
  def perform
    Lands::Corrector.new.call
  end
end
