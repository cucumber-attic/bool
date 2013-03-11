module Win32
  module Resolv
    def get_hosts_path
      '/etc/hosts'
    end
    module_function :get_hosts_path
  end
end
