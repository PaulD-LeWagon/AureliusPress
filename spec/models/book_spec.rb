# == Schema Information
#
# Table name: books
#
#  id              :bigint           not null, primary key
#  name            :string
#  slug            :string
#  creator_id      :integer
#  status          :string
#  privacy_setting :string
#  alt_title       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe Book, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
