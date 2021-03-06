# frozen_string_literal: true

require 'aws-sdk'
require 'time'
require 's3browser/store'

module S3Browser
  class Fetch
    raise 'Unconfigured' unless ENV['AWS_REGION']

    class Store < S3Browser::Store
      plugin :es
      plugin :images
    end

    def run
      s3.list_objects(bucket: bucket).contents.map do |object|
        info = s3.head_object(
          bucket: bucket,
          key: object.key
        )

        info = info.to_h.merge(object.to_h)
        store.add bucket, info
      end
    rescue Aws::S3::Errors::PermanentRedirect
      puts "Could not connect to bucket #{bucket}"
    end

    private

    def bucket
      @bucket ||= ENV['AWS_S3_BUCKET']
    end

    def s3
      @s3 ||= Aws::S3::Client.new
    end

    def store
      @store ||= Store.new('s3browser')
    end
  end
end

S3Browser::Fetch.new.run if $PROGRAM_NAME == __FILE__
