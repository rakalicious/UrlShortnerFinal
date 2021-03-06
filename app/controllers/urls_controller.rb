class UrlsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :is_session_over_yes, only: [:new]
  #before_action :is_session_over_no, only: []
  #before_action :session_timeout, only: [:new]

  include UrlsHelper
  require 'date'
  require 'time'
 
  def new
  end

=begin
api for long to short (POST)
inp = POST  http://0.0.0.0:3000/urls/long_to_short ....... and in body    {"long_url_inp" : "www.youtube.com/charmander"}
out = {"short_domain": "yt.ub",
    "short_url": "1R9ixp3"}
=end
  def long_to_short
    respond_to do |format|

      if long_url_params.empty?
        format.html {render 'urls/new'}
        format.json {render json: {"error" => "Entry"}, status: :not_found}
      else
      domain_name = DomainsHelper.get_domain_name_from_url(long_url_params[:long_url_inp])
      @req_ans = Url.shorten_url(long_url_params[:long_url_inp] , domain_name)
        if @req_ans == false
          @req_ans = ""
          flash.now[:error] = "Domain not registered"
          format.html {render 'urls/new'}
          format.json {render json: {"error" => "Domain not registered"}, status: :not_found}
        end

        format.html {render 'urls/new'}
        format.json { render json: {"short_domain" => @req_ans.split("/").first , "short_url" => @req_ans.split("/").last}, status: :ok}
      end
    end
  end

=begin
api for short to long
inp = GET  http://0.0.0.0:3000/urls/short_to_long?short_url_inp .... and in body     {"short_url_inp" : "T4NKQPa"}
out = {"long_url":"www.youtube.com/ninetails"}
=end
  def short_to_long
    respond_to do |format|
      if short_url_params.empty?
        format.html {render 'urls/new'}
        format.json {render json: {"error" => "Entry"}, status: :not_found}
      else
        short_inp = short_url_params[:short_url_inp]
        if short_inp.include? "/"
          short_inp = short_inp.split("/").second
        end
        @req_ans = Url.find_long_url(short_inp)
        if @req_ans == false
          @req_ans = ""
          flash.now[:error] = "no such short url"
          format.html {render 'urls/new'}
          format.json {render json: {"error" => "Short url does not exist"}, status: :not_found}
        end
        format.html {render 'urls/new'}
        format.json { render json: {"long_url" => @req_ans}, status: :ok}
      end
    end
  end
=begin
logout button
=end
  def logout
    close_session
  end

  private
    def short_url_params
      #params.require(:long_url_inp)
      params.permit(:short_url_inp)
    end
    def long_url_params
      #params.require(:long_url_inp)
      params.permit(:long_url_inp)
    end
  
end
