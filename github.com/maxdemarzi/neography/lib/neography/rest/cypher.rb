module Neography
  class Rest
    class Cypher
      include Neography::Rest::Helpers

      def initialize(connection)
        @connection = connection
      end

      def query(query, parameters = {}, cypher_options = nil)
        options = {
          :body => {
            :query => query,
            :params => parameters
          }.to_json,
          :headers => json_content_type.merge({'Accept' => 'application/json;stream=true'})
        }
        
        @connection.post(optioned_path(cypher_options), options)
      end
      
      private
      def optioned_path(cypher_options = nil)
        return @connection.cypher_path unless cypher_options
        options = []
        options << "includeStats=true" if cypher_options[:stats]
        options << "profile=true" if cypher_options[:profile]
        @connection.cypher_path + "?" + options.join("&")
      end

    end
  end
end
