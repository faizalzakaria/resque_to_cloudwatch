require 'aws-sdk-v1'

module ResqueToCloudwatch
  class Config

    attr_reader :access_key_id, :secret_access_key, :regions
    attr_reader :redis_host, :redis_port
    attr_reader :namespace, :project, :hostname

    def initialize(options)
      @access_key_id = options[:access_key_id]
      @secret_access_key = options[:secret_access_key]
      @regions = options[:regions]
      @redis_host = options[:redis_host]
      @redis_port = options[:redis_port]
      @namespace = options[:namespace]
      @project = options[:project]
      @hostname = options[:hostname]

      # Set up AWS credentials
      AWS.config(
        access_key_id: @access_key_id,
        secret_access_key: @secret_access_key
      )
    end
  end
end
