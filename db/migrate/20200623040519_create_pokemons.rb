class CreatePokemons < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.string :image
      t.string :description
      t.string :type1
      t.string :type2
      t.integer :weight
      t.integer :base_exp
      t.string :evolutions, array: true, default: []


      t.timestamps
    end
  end
end
