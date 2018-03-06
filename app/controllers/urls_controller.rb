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
    if url_params[:original_url]
      @url = Url.new(url_params)
      if @url.new_url?
        if @url.save
            @http_code = 201
            flash[:notice] = "Status:#{@http_code}. Here is your link to shortened url"
            redirect_to shortened_path(@url.short_url)
        end
      else
        @http_code = 409
        flash[:notice] = "Status:#{@http_code}. A short link for this URL is already in our database"
        redirect_to shortened_path(@url.find_duplicate.short_url)
      end
    elsif url_params[:short_url]
      @url = Url.find_by_short_url(url_params[:short_url])
      if @url.nil?
        @http_code = 404
        flash.now[:notice] = "Status:#{@http_code}. Verify the shortened url link"
        render "index"
      elsif @url.valid?
        @http_code = 302
        flash[:notice] = "Status:#{@http_code}. Original URL found"
        redirect_to shortened_path(@url.short_url)
      end
    end
  end

  private

  def find_url
    @url = Url.find_by_short_url(params[:short_url])
  end

  def url_params
    params.require(:url).permit(:original_url, :short_url)
  end
end
