module ActsAsStatusChangeable
  VERSION = "0.0.1"

  module ClassMethods
    def self.included(base)
      base.extend(ClassMethods)
    end
  end

  module ClassMethods
    def acts_as_status_changeable(*statusses)
      class_attribute :acts_as_status_changeable_statuses
      self.acts_as_status_changeable_statuses = []

      statusses = statusses.map(&:to_s)
      raise "Nie podales nazwy statusu, który ma być zapisywany." if statusses.empty?
      statusses.each do |status|
        if table_exists? && column_names.include?(status)
          self.acts_as_status_changeable_statuses << status
        else
          Rails.logger.warn "Model nie zawiera kolumny \"'#{status}\""
        end
      end

      has_many :status_changes, :as => :status_changeable
      before_save :save_status_change

      scope :with_past_status, lambda {|status_name, status| {:include => :status_changes, :conditions => {:status_changes => {:status => status.to_s, :status_name => status_name.to_s }}} }

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
      if status_change = self.status_changes.find_by_status_name_and_status(status_name.to_s, status.to_s)
        return status_change.created_at
      else
        return nil
      end
    end

    # Looks for changes in any of tracked statuses and builds +status_changes+ instances reflecting those changes.
    def save_status_change
      Rails.logger.info("Status changed")
      self.class.acts_as_status_changeable_statuses.each do |status|
        current_status = self.send(status)
        if self.send("#{status.to_s}_changed?") # nil jest dla nowego rekordu
          self.status_changes.build(:status_changeable_id => self,
                                                  :status_name => status.to_s,
                                                  :status => current_status)
        end
      end
    end

  end
end

