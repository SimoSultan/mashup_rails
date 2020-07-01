class CreateStudentsTeachers < ActiveRecord::Migration[6.0]
  def change
    create_table :students_teachers do |t|
      t.references :student, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true

      t.timestamps
    end
  end
end
