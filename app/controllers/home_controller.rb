class HomeController < ApplicationController
  def index
    @title = "Home - AureliusPress CMS (Content Management System)"
    @subtitle = "Your Personal Document Management System"
    @description = [
      "Welcome to AureliusPress, your personal document management system.",
      "Easily manage your documents, notes, and blog posts with a user-friendly interface.",
      "AureliusPress is designed to help you organize your content efficiently.",
      "Whether you're a writer, researcher, or just need a place to keep your documents, AureliusPress has you covered.",
      "Join our community and start managing your documents today!"
    ] + Faker::Lorem.paragraphs(number: 7, supplemental: true)
    @keywords = "AureliusPress, document management, personal documents, PWA"
  end
end
