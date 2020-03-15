require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :rack_test#, using: :headless_chrome, screen_size: [1400, 1400]
end
