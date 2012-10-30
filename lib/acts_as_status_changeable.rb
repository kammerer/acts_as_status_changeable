module ActsAsStatusChangeable
  VERSION = "0.0.1"

  module ClassMethods
    def self.included(base)
      base.extend(ClassMethods)
    end
  end

  module ClassMethods
    def acts_as_status_changeable(*statuses)
      raise ArgumentError, "At least one status name is required"
      raise RuntimeError, "Model table does not exist" unless table_exists?

      statuses = statuses.map(&:to_s)

      class_attribute :acts_as_status_changeable_statuses
      self.acts_as_status_changeable_statuses = []

      statuses.each do |status|
        unless column_names.include?(status)
          raise ArgumentError, "Model table does not contain '#{status}' column"
        end

        self.acts_as_status_changeable_statuses << status
      end

      has_many :status_changes, :as => :status_changeable
      before_save :build_status_changes

      scope :with_past_status, lambda { |status_name, status|
        includes(:status_changes).where(:status_changes => { :status => status.to_s, :status_name => status_name.to_s })
      }

      include InstanceMethods
    end
  end

  module InstanceMethods

    # Checks whether object ever was in given status.
    #
    # Args:
    #   status_name [String|Symbol]
    #   status [String|Symbol]
    def was_in_status?(status_name, status)
      status_changes.exists?(:status_name => status_name.to_s, :status => status.to_s)
    end

    # Returns time of most recent change of +status_name+ attribute to given +status+ (or +nil+).
    #
    # Example:
    #   self.status_date(:status, :active)            # => Mon, 20 Apr 2009 12:12:20 UTC +00:00
    #   self.status_date(:financial_status, :paid)    # => nil
    def status_date(status_name, status)
      status_changes.order("created_at DESC").where(:status_name => status_name.to_s, :status => status.to_s).first.try(:created_at)
    end

    # Looks for changes in any of tracked statuses and builds +status_changes+ instances reflecting those changes.
    def build_status_changes
      self.class.acts_as_status_changeable_statuses.each do |status|
        current_status = self.send(status)
        if self.send("#{status.to_s}_changed?") # nil when new_record?
          self.status_changes.build(:status_changeable_id => self,
                                    :status_name => status.to_s,
                                    :status => current_status)
        end
      end
    end
  end
end

