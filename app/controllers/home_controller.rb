class HomeController < ApplicationController
  def index
    @time = Time.zone.now
  end
end