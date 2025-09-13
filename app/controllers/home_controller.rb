class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    @title = "AureliusPress CMS"
    @subtitle = "Your Personal Document Management & Journaling System"
    @description = [
      "Welcome to AureliusPress!",
      "Easily manage your documents, notes, and blog posts with a user-friendly interface.",
      "AureliusPress is designed to help you organize your content efficiently.",
      "Whether you're a writer, researcher, or just need a place to keep your documents, AureliusPress has you covered.",
      "Join our community and start managing your documents today!"
    ] + Faker::Lorem.paragraphs(number: 7, supplemental: true)
    @keywords = "AureliusPress, document management, personal documents, PWA"
  end
end
