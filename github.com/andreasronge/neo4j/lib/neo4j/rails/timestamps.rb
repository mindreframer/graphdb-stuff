module Neo4j
  module Rails
    # Handle all the created_at, updated_at, created_on, updated_on type stuff.
    module Timestamps
      extend ActiveSupport::Concern

      TIMESTAMP_PROPERTIES = [:created_at, :created_on, :updated_at, :updated_on]

      included do
        before_create :create_timestamp
        before_save :update_timestamp, :if => :new_or_changed?
      end
      # Set the timestamps for this model if timestamps is set to true in the config
      # and the model is set up with the correct property name, e.g.:
      #
      #   class Trackable < Neo4j::Rails::Model
      #     property :updated_at, :type => DateTime
      #   end
      def update_timestamp
        #definition provided whenever an :updated_at property is defined
      end

      # Set the timestamps for this model if timestamps is set to true in the config
      # and the model is set up with the correct property name, e.g.:
      #
      #   class Trackable < Neo4j::Rails::Model
      #     property :created_at, :type => DateTime
      #   end
      def create_timestamp
        #definition provided whenever an :created_at property is defined
      end

      # Write the timestamp as a Date, DateTime or Time depending on the property type
      def write_date_or_timestamp(attribute)
        value = case self.class._decl_props[attribute.to_sym][:type].to_s
                  when "DateTime"
                    DateTime.now
                  when "Date"
                    Date.today
                  when "Time"
                    Time.now
                end
        send("#{attribute}=", value)
      end

      def new_or_changed?
        self.new? or self.changed?
      end

      module ClassMethods
        def property_setup(property, options)
          super
          define_timestamp_method(:create_timestamp, :created_at) if property == :created_at
          define_timestamp_method(:update_timestamp, :updated_at) if property == :updated_at
          # ensure there's always a type on the timestamp properties
          if Neo4j::Config[:timestamps] && TIMESTAMP_PROPERTIES.include?(property)
            if _decl_props[property][:converter] == Neo4j::TypeConverters::DefaultConverter
              _decl_props[property][:type] = Time
              _decl_props[property][:converter] = Neo4j::TypeConverters.converter(Time)
            end
          end
        end

        def define_timestamp_method(method_name, property)
          class_eval <<-RUBY, __FILE__, __LINE__
						def #{method_name}
							write_date_or_timestamp(:#{property}) if Neo4j::Config[:timestamps]
						end
          RUBY
        end
      end
    end
  end
end
