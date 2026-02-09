class AddBirthDateAndDeathDateToAureliusPressAuthors < ActiveRecord::Migration[7.2]
  def change
    add_column :aurelius_press_authors, :birth_date, :date
    add_column :aurelius_press_authors, :death_date, :date
  end
end
