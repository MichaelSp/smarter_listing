require "application_system_test_case"

class WorkflowTest < ApplicationSystemTestCase
  test "has index" do
    visit "/listings"
    page.has_css? '.count', text: '1'
    page.has_link? '.sortable', count: 2
    page.has_link? '.copy', count: 1
    page.has_link? '.edit', count: 1
    page.has_link? '.destroy', count: 1
  end
end
