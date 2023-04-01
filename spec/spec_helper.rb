require './lib/canvas'
require './lib/operations/bucket_fill'
require './lib/operations/draw_line'
require './lib/operations/draw_rectangle'
require './lib/operations/new_canvas'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.order = :random
end

module Helpers
  def self.empty_canvas?(canvas)
    canvas.matrix.each do |row|
      row.each do |cell|
        return false if cell != ' '
      end
    end
    true
  end
end
