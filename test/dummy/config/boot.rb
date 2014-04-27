# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../../Gemfile', __FILE__)

$LOAD_PATH << "/opt/workspace/blessed/core/vendor/gems/gems/bundler-1.5.2/lib"

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
$LOAD_PATH.unshift File.expand_path('../../../../lib', __FILE__)
