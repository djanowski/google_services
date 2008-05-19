module Google
  module ControllerExtensions
    def self.included(controller)
      controller.after_filter :append_google_analytics
    end

    def append_google_analytics
      return unless Google::Analytics.configured? && layout && request.format === Mime::HTML

      Google::Analytics.inject_code(response.body)
    end
  end
end
