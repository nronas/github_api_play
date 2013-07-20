require 'httparty'
Dir[File.expand_path('lib/*.rb')].each{ |f| require f }

Bundler.require(:test) if defined?(Bundler)
