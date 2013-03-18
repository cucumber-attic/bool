# This file will not be packaged in the gem.
# It is only used during build, to work around this issue:
# https://github.com/cucumber/bool/issues/37
module Win32
  module Resolv
    def get_hosts_path
      '/etc/hosts'
    end
    module_function :get_hosts_path
  end
end
