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

      def usesguid(options = {})
        options[:as] ||= :primary_key

        class_eval do
          if options[:as] == :primary_key && options[:column]
            self.primary_key = options[:column]
          end

          before_validation :assign_guid

          def assign_guid
            self[ActiveRecord::Base.guid_column] ||= (ActiveRecord::Base.guid_generator == :database ?
                                                UUID.send( "#{ActiveRecord::Base.connection.adapter_name.downcase}_create" ) :
                                                UUID.timestamp_create).send( "to_#{ActiveRecord::Base.guid_compression}" )
          end

        end

      end

      def validate_guid( options={} )
        validates_presence_of( ActiveRecord::Base.guid_column )
        validates_uniqueness_of( ActiveRecord::Base.guid_column )
        validates_length_of( ActiveRecord::Base.guid_column, :maximum => (ActiveRecord::Base.guid_compression == 's22' ? 22 : 36), :allow_blank => true )
      end

    end

  end
end
