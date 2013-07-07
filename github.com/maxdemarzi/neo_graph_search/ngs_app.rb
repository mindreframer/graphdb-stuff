require "sinatra/reloader"

class App < Sinatra::Base

  configure :development do |config|
      register Sinatra::Reloader
      config.also_reload "lib/ngs/**/*"
    end

  use Rack::Session::Cookie , :secret => (ENV['SESSION_SECRET'] || "82e042cd6fde2bf1764f777236db799e")
  
  fields = ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location", "skills"]

  use OmniAuth::Builder do
    provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'], :scope => 'user_likes, user_location, friends_likes, friends_location', :client_options => {:ssl => {:ca_file => "./cacert.pem"}}
  end

  Dir.glob(File.dirname(__FILE__) + '/helpers/*', &method(:require))
  helpers App::Helpers

  # Homepage
  get '/' do
    if current_user.nil?
      haml :index, :layout => :layout
    else
      redirect to("/user/#{current_user.uid}")
    end
  end

  # Authentication
  ['get', 'post'].each do |method|
    send(method, "/auth/:provider/callback") do
      user = User.create_with_omniauth(env['omniauth.auth'])
      session[:uid] = user.uid

      redirect to(session[:redirect_url] || "/user/#{session[:uid]}")
      session[:redirect_url] = nil
    end
  end

  get '/auth/failure/?' do
    raise 'auth error'
  end

  get '/logout/?' do
    session.clear
    redirect to('/')
  end

  # Users
  get '/user/:id' do
    @user = user(params[:id])
    @friends_count = @user.friends_count
    @likes_count = @user.likes_count
    haml :'user/show'
  end

  get '/user/:id/friends' do
    @user = user(params[:id])
    @friends = @user.friends
    haml :'user/index'
  end

  get '/user/:id/likes' do
    @user = user(params[:id])
    @things = @user.likes
    haml :'thing/index'
  end

  get '/user/:id/search' do
    @user = user(params[:id])
    @q = params[:q] || "friends"
    @q = "friends" if @q == "people"
    begin 
      @cypher = NGS::Parser.parse("(#{@q})")
      @cypher[0] = @cypher[0] +  " , people.uid, people.name, people.image_url LIMIT 100"
      @cypher[1].merge!({"me" => @user.neo_id}) if @cypher[1].has_key?("me")
      @people = $neo_server.execute_query(@cypher[0].to_s, @cypher[1])["data"]
      @cypher[0].gsub!("MATCH", "<br>MATCH")
      @cypher[0].gsub!("RETURN", "<br>RETURN")
      @cypher[0].gsub!("LIMIT", "<br>LIMIT")
    rescue Exception => e
      @cypher = ["Sorry, I didn't understand, please try a different search."]
      @people = []
    end
    haml :'user/search'
  end


  get '/user/:id/visualization' do
    @user = user(params[:id])
    haml :'user/visualization'
  end

  get '/visualization' do
    @user = current_user
    random_number = 20 + Random.rand(31)
    @user.friend_matrix.sample(random_number).map{|fm| {"name" => fm[0], "follows" => fm[1]} }.to_json
  end

  # Things
  get '/thing/:id' do
    @thing = Thing.get_by_id(params[:id])
    @users = @thing.users
    haml :'thing/show'
  end

end
