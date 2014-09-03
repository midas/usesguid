# from Demetrio Nunes
# Modified by Andy Singleton to use different GUID generator
# Further modified by Brian Morearty to:
# 1. optionally use the MySQL GUID generator
# 2. respect the "column" option
# 3. set the id before create instead of after initialize
#
# MIT License
module Usesguid
  module ActiveRecordExtensions

    def self.included( base )
      super
      base.extend( ClassMethods )
    end


    module ClassMethods
      # guid_generator can be :timestamp or :mysql
      def guid_generator=(generator); class_eval { @guid_generator = generator } end
      def guid_generator; class_eval { @guid_generator || :timestamp } end

      def guid_compression=(compression); class_eval { @guid_compression = compression } end
      def guid_compression; class_eval { @guid_compression || 's' } end

      def guid_column=(column); class_eval { @guid_column = column } end
      def guid_column; class_eval { @guid_column || 'id' } end

      def guid_callback=(callback)
        class_eval do
          # Make sure that the callback provided is a valid ActiveRecord callback.
          # NOTE: Since some versions of Rails return the Array of valid callbacks as
          # symbols and some return an array of Strings we will map the Array to
          # all strings and validate the user's callback as a string against it.
          unless ActiveRecord::Callbacks::CALLBACKS.
              map{|cb| cb.to_s}.include? callback.to_s
            raise ArgumentError, "Unknown callback: #{callback.inspect}"
          end
          @guid_callback = callback
        end
      end
      def guid_callback; class_eval { @guid_callback || :before_create } end

      def usesguid(options = {})
        options[:as] ||= :primary_key

        class_eval do
          if options[:as] == :primary_key && options[:column]
            self.primary_key = options[:column]
          end

          # Per http://apidock.com/rails/v2.3.8/ActiveRecord/Callbacks the
          # after_initialize method must be defined before an after_initialize
          # callback will be used.  Define it here if we need it.
          if ActiveRecord::Base.guid_callback.to_s == 'after_initialize'
            def after_initialize; end
          end

          # Set our callback here
          self.send(ActiveRecord::Base.guid_callback, :assign_guid)

          def assign_guid
            self[ActiveRecord::Base.guid_column] ||=
                (ActiveRecord::Base.guid_generator == :database ?
                  UUIDTools::UUID.send( "#{ActiveRecord::Base.connection.adapter_name.downcase}_create" ) :
                    UUIDTools::UUID.timestamp_create
                ).send( "to_#{ActiveRecord::Base.guid_compression}" )
          end

        end

      end

      def validate_guid( options={} )
        validates_presence_of( ActiveRecord::Base.guid_column )
        validates_uniqueness_of( ActiveRecord::Base.guid_column )
        validates_length_of( ActiveRecord::Base.guid_column,
                             :maximum => (ActiveRecord::Base.guid_compression == 's22' ?
                                 22 : 36),
                             :allow_blank => true )
      end

    end

  end
end
