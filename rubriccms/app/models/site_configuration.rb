class SiteConfiguration < ActiveRecord::Base

  # Behaviours
  before_save :check_for_activation

  # Validations
  validates_presence_of :site_name
  
  # Dynamically build singleton class methods to access values of active configuration
  method_declarations = ""
  self.column_names.each do |m|
    method_declarations << %{
      def self.#{m.to_s}
        active_configuration.#{m}
      end
      def self.#{m.to_s}=(value)
        active_configuration.update_attributes(#{m}, value)
      end
    }
  end
  eval method_declarations

  def self.active_configuration
    SiteConfiguration.find_by_active(true) || RubricCms::Config
  end

  # Only one configuration can be active at a time.  
  def check_for_activation
    SiteConfiguration.all.each{ |a| a.update_attribute(:active, false) unless a == self } if self.active?
  end


end
