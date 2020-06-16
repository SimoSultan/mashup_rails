class BooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :setup_data
  # before_action :test_before
  # after_action :test_after
  @@books = []

  def home
      # render json: @data
      # render html: "<h1>Honey I am home</h1>".html_safe
      @books = @@books
  end

  #Show a single book
  def show
    @book = params
  end

  #Create a new book
  def create
    @article_title = "Title: #{params[:article][:title]}"
    @author = "Author: #{params[:article][:author]}"
    @content = "Content: #{params[:article][:content]}"
    @@books.push({title: @title, author: @author, content: @content})
    render 'about'
  end

  def about
    @title = "The new book just added to the list"
    @article_title
    @author
    @content
  end

  def test_before
    p "before"
    # p params["controller"]
  end

  # def test_before_2
  #   p "before 2"
  #   p params[:controller]

  # end

  def test_after
    p "after"
  end

  # #Update a book
  # def update
  # end

  # #Remove a book
  # def destroy
  # end

  private
  def setup_data
      @@books = [
          { title: "Harry Potter", author: "J.K Rowling" },
          { title: "Name of the Wind", author: "Patrick Rothfuss" }
      ]
  end
end
