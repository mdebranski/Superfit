class CreateModels < ActiveRecord::Migration
  def change
    create_table :wods do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.string :category, null: false
      t.string :scoring_method, null: false
      t.text :workout_male
      t.text :workout_female
      t.text :scoring_notes
      t.text :workout_notes
    end

    create_table :strengths do |t|
      t.string :name, null: false
    end

    create_table :exercises do |t|
      t.string :name, null: false
      t.string :category, null: false
    end

    create_table :foods do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.integer :serving_size, null: false
      t.text :nutritional_info, null: false
    end

    create_table :users do |t|
      t.string :name, null: false
      t.string :location
      t.string :gender
      t.string :picture
      t.string :facebook_id
    end

    create_table :food_entries do |t|
      t.string :user_id, null: false
      t.string :food_id, null: false
      t.integer :amount, null: false
      t.string :units, null: false
    end

  end
end
