module ActsAsStatusChangeable 
  class StatusChange < ActiveRecord::Base
    belongs_to :status_changeable, :polymorphic => true
  end
end

