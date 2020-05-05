require 'finale/version'
require 'finale/client'
require_relative '../spec/test_support'
require_relative '../spec/client_mock'

module Finale
  def self.root
    @root ||= Pathname.new(File.dirname(File.expand_path(File.dirname(__FILE__), '/../')))
  end
end
