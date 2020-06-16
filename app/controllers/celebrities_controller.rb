class CelebritiesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :setup_data
  
  #Show all celebrities
  def home
    @celebrities
  end
  
  #Show a single celebrity
  def show
    @celebrity = params
  end
  
  #Create a new celebrity
  def create
    name = params[:name]
    notability = params[:notability]
    
    if @celebrities.any? {|h| h["name"] == name}
      render plain: "Sorry this celebrity already exists"
    else
      @celebrities.push({"name" => name, "notability" => notability})
      render 'home'
    end

  end
  
  #Update a celebrity
  def update
  end
  
  #Remove a celebrity
  def destroy
  end

  private
  def setup_data
      session[:celebrities] = [
          { "name" => "Lindsay Lohan", "notability" => "Parent Trap" },
          { "name" => "Adam Sandler", "notability" => "Big Daddy" },
          { "name" => "Rob Schnider", "notability" => "Adam Sandler" }
      ] unless session[:celebrities]
  
      @celebrities = session[:celebrities]
  end
end