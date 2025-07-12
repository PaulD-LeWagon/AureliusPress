# app/models/note.rb
class Note < Document
  # after_initialize :set_visibility
  # Notes are always private visibility
  # def set_visibility
  #   self.visibility = :private_to_owner
  # end
end
