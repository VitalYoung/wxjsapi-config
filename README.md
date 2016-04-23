# Wxjsapi::Config

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/wxjsapi/config`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wxjsapi-config'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wxjsapi-config

## Usage

```ruby
wx_config = Wxjsapi.Config.WechatConfig([appId], [appSecret], [jsapilist]) # jsapilist 需要使用微信jsapi的功能，如 "onMenuShareTimeline,onMenuShareAppMessage"
wx_config.wxJsSDKSign([url])  # 生成微信jsapi需要的参数。使用微信jsapi页面的url
wx_config 可以使用的微信jsapi参数有 :appId, :timestamp, :nonceStr, :signature, :jsApiList

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/wxjsapi-config. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

