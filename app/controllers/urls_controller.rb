class UrlsController < ApplicationController
  before_action :find_url, only: [:show, :shortened]

  # GET /urls
  def index
    @url = Url.new
  end

  # GET /urls/1
  # GET /urls/1.json
  def show
    redirect_to @url.short_url
  end

  # POST /urls
  # POST /urls.json
  def create
    @url = Url.new(url_params)
    @http_code = 201
    if @url.new_url?
      if @url.save
         flash[:notice] = "Status:#{@http_code}. Here is your link to shortened url"
        redirect_to shortened_path(@url.short_url)
      else
        flash[:error] = "Check the error below:"
        render 'index'
      end
    else
      @http_code = 409
      flash[:notice] = "Status:#{@http_code}. A short link for this URL is already in our database"
      redirect_to shortened_path(@url.find_duplicate.short_url)
    end
  end

  private

  def find_url
    @url = Url.find_by_short_url(params[:short_url])
  end

  def url_params
    params.require(:url).permit(:original_url)
  end
end
