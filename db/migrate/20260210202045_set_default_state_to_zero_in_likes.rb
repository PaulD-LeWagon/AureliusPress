class SetDefaultStateToZeroInLikes < ActiveRecord::Migration[7.2]
  def change
    change_column_default :aurelius_press_likes, :state, from: nil, to: 0
    # Data is not live, but if it were we would update existing records
    # Like.update_all(state: 0) if Like.where(state: nil).exists?
  end
end
