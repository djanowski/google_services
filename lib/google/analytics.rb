require 'rubygems'
require 'active_support'

module Google
  class Analytics
    cattr_accessor :code

    def self.track(code)
      @@code = code
    end

    def self.configured?
      !code.blank?
    end

    def self.javascript_code
      return '' if code.blank?

      tracker_line = "urchinTracker();"
      
      tracker_line = "// Not tracking on #{rails_env} environment.\n    // #{tracker_line}" unless rails_env == 'production'

      %{
  <script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
  <script type="text/javascript">
    _uacct = '#{code}';
    #{tracker_line}
  </script>
      }
    end

    def self.inject_code(str)
      str.gsub!('</body>', "#{javascript_code}\n</body>")
    end

    def self.rails_env
      RAILS_ENV rescue 'production'
    end
  end
end
