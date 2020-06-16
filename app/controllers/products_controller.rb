class ProductsController < ApplicationController
  def home
    @products = ["Toothbrush", "Sweater", "Waterbottle"]
  end
end
