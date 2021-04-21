require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400], options: {
    url: "http://selenium:4444/wd/hub",
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %w[headless window-size=1600x1080 no-sandbox disable-dev-shm-usage] },
    )
  }

  def setup
    Capybara.server_host = "0.0.0.0"
    Capybara.server = :puma, { Threads: "1:1" }
    Capybara.always_include_port = true
    Capybara.app_host = "http://app:#{Capybara.current_session.server.port}"
    super
  end
end
