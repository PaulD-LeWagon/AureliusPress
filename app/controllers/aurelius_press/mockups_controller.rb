module AureliusPress
  class MockupsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:tyrian_purple]
    layout "aurelius_press/mockup"

    def tyrian_purple
      # Static mockup, no data needed yet
    end
  end
end
