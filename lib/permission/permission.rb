require 'json'
require_relative '../header/secure_header'

module Azure
  module DocumentDB
    class Permission
      def initialize context, rest_client
        self.context = context
        self.rest_client = rest_client
        self.resource_type = "permissions"
        self.parent_resource_type = "users"
        self.secure_header = Azure::DocumentDB::SecureHeader.new context.master_token, resource_type
      end

      def list database_id, user_id
        url = url database_id, user_id
        header = secure_header.header "get", user_id
        JSON.parse(rest_client.get url, header)
      end

      private
      attr_accessor :context, :rest_client, :resource_type, :parent_resource_type, :secure_header

      def url database_id, user_id, resource_id = nil
        target = "/" + resource_id if resource_id
        "#{context.endpoint}/dbs/#{database_id}/#{parent_resource_type}/#{user_id}/#{resource_type}#{target}"
      end
    end
  end
end