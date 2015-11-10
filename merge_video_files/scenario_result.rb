class ScenarioResult < ActiveRecord::Base
  has_many :result_steps, inverse_of: :scenario_result
  has_many :step_videos, -> { order offset_seconds: :asc }, through: :result_steps
end
