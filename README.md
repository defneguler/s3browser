# S3Browser

The S3Browser is a simple wrapper around Amazon's [S3 Service](https://aws.amazon.com/s3/).
Apart from listing files and managing, S3 doesn't give you a lot of functionality.

This wrapper gives you a couple of killer functions:

* [x] Search
* [x] Sorting
* [ ] Automatically update file information
* [ ] Upload files
* [ ] Download files

## Installation

Add this line to your application's Gemfile:

```ruby
gem 's3browser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install s3browser

## Usage

Here's an example config.ru for booting S3Browser::Server in your choice of Rack server:

```ruby
# config.ru
require 's3browser/server'
run S3Browser::Server
```

You can mount S3Browser to existing Rack (Sinatra) application as well:

```ruby
# config.ru
require 'your_app'

require 's3browser/server'
run Rack::URLMap.new('/' => Sinatra::Application, '/s3browser' => S3Browser::Server)
```

To run S3Browser rake files, require the tasks file:

```ruby
# Rakefile
require 's3browser/gem_tasks'
```

Run the fetcher

```bash
bundle exec rake s3browser:fetch
```

Run the server

```bash
bundle exec rake s3browser:server
```

## Real time updates

S3 buckets can be configured to send [Event Notifications](http://docs.aws.amazon.com/AmazonS3/latest/dev/NotificationHowTo.html)
when certain events happen in a bucket.

### Setup

Run `bundle exec rake s3browser:setup` to ensure the correct ENV variables are set, and that your AWS setup is correct.

It will:

1. Record the neccesary ENV variables:
  * AWS_ACCESS_KEY_ID
  * AWS_SECRET_ACCESS_KEY
  * AWS_REGION
  * AWS_S3_BUCKET
  * AWS_SQS_QUEUE
2. Create the SQS queue, with the correct permissions
3. Create the S3 bucket, with the correct notification configuration

To do the setup, the IAM profile you're using to run the script should have the following policy in place:

```javascript
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3BrowserFullAccess",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:ListBucket",
                "s3:PutObject",
                "s3:CreateBucket",
                "s3:PutBucketNotification"
            ],
            "Resource": [
                "arn:aws:s3:::*",
                "arn:aws:s3:::*/*"
            ]
        },
        {
            "Sid": "Stmt1460660107000",
            "Effect": "Allow",
            "Action": [
                "sqs:DeleteMessage",
                "sqs:ReceiveMessage",
                "sqs:CreateQueue",
                "sqs:GetQueueUrl",
                "sqs:GetQueueAttributes",
                "sqs:SetQueueAttributes"
            ],
            "Resource": [
                "arn:aws:sqs:*"
            ]
        }
    ]
}
```

After setting up the queue and the bucket, a policy **without** the following actions can be used:

* s3:CreateBucket
* s3:PutBucketNotification
* sqs:CreateQueue
* sqs:GetQueueUrl
* sqs:GetQueueAttributes
* sqs:SetQueueAttributes

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jrgns/s3browser.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

