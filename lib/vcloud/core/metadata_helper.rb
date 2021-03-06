module Vcloud
  module Core
    module MetadataHelper

      # Convert the fog metadata into a hash of standard Ruby types
      # Fog and vCloud currently expose the types used in the API, which are
      # unnecessary for most needs. This class maps those custom Fog types back
      # to Ruby types if possible.
      #
      # @param vcloud_metadata_entries [Hash] vCloud data as returned from Fog
      # @return [Hash] a hash of only the metadata using Ruby types
      def extract_metadata vcloud_metadata_entries
        metadata = {}
        vcloud_metadata_entries.each do |entry|
          next unless entry[:type] == Vcloud::Core::Fog::ContentTypes::METADATA
          key = entry[:Key].to_sym
          val = entry[:TypedValue][:Value]
          case entry[:TypedValue][:xsi_type]
            when Fog::MetadataValueType::Number
              val = val.to_i
            when Fog::MetadataValueType::String
              val = val.to_s
            when Fog::MetadataValueType::DateTime
              val = DateTime.parse(val)
            when Fog::MetadataValueType::Boolean
              val = val == 'true' ? true : false
          end
          metadata[key] = val
        end
        metadata
      end

      module_function :extract_metadata
    end
  end
end
