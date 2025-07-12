class HomeController < ApplicationController
  def index
    @documents = Document.all
    @title = "Home - AureliusPress"
    @subtitle = "Your Personal Document Management System"
    @description = "Welcome to AureliusPress, your personal document management system."
    @keywords = "AureliusPress, document management, personal documents, PWA"
  end
end
