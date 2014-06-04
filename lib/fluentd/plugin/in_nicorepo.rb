require 'nicorepo'

module Fluentd
  class NicorepoInput < Fluent::Input
    Plugin.register_input 'nicorepo' self
  end
end

