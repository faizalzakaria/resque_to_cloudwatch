require 'redis'

module ResqueToCloudwatch
  class QueueLengthCollector

    def initialize(config)
      @config = config
    end

    def get_value
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      redis.smembers('resque:queues').map do |queue_key|
        redis.llen("resque:queue:#{queue_key}")
      end.reduce(:+)
    end

    def metric_name
      "resque_queues"
    end

    def to_s
      metric_name
    end

  end

  class WorkersWorkingCollector

    def initialize(config)
      @config = config
    end

    def get_value
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      redis.smembers('resque:workers').select do |worker_key|
        redis.exists("resque:worker:#{worker_key}")
      end.length
    end

    def metric_name
      "resque_workers_working"
    end

    def to_s
      metric_name
    end

  end

  class WorkersAliveCollector

    def initialize(config)
      @config = config
    end

    def get_value
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      redis.smembers('resque:workers').length
    end

    def metric_name
      "resque_workers_alive"
    end

    def to_s
      metric_name
    end

  end

  class WorkRemainingCollector

    def initialize(config)
      @config = config
    end

    def get_value
      redis = Redis.new(:host => @config.redis_host, :port => @config.redis_port)
      working = redis.smembers('resque:workers').select do |worker_key|
        redis.exists("resque:worker:#{worker_key}")
      end.length
      queue_length = redis.smembers('resque:queues').map do |queue_key|
        redis.llen("resque:queue:#{queue_key}")
      end.reduce(:+)
      working + queue_length
    end

    def metric_name
      "resque_work_remaining"
    end

    def to_s
      metric_name
    end

  end
end
