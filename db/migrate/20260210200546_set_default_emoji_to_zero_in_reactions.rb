class SetDefaultEmojiToZeroInReactions < ActiveRecord::Migration[7.2]
  def change
    change_column_default :aurelius_press_reactions, :emoji, from: nil, to: 0
    # Ensure any existing nil values are updated to 0
    # Reaction.update_all(emoji: 0) if Reaction.exists?
    # Since model is not yet updated, let's use SQL directly or just relying on default for new records.
    # Given user said "no live data", strictly setting default is enough.
  end
end
