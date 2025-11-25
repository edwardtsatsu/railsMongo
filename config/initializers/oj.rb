# Use Oj as Rails JSON encoder
require "oj"

Oj.optimize_rails

# Optional: default options
Oj.default_options = {
  mode: :compat,      # Rails-compatible mode
  use_to_json: true,  # call `to_json` if defined
  time_format: :ruby  # format times like Rails
}
