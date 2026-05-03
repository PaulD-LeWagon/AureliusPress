SimpleCov.start "rails" do
  minimum_coverage 70
  add_filter "/spec/"
  add_filter "/config/"
  add_filter "/vendor/"
  add_filter "/db/"
end
