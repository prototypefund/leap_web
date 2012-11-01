class SessionsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def new
  end

  def create
    @user = User.find_by_param(params[:login])
    session[:handshake] = @user.initialize_auth(params['A'].hex)
    render :json => session[:handshake]
  rescue RECORD_NOT_FOUND
    render :json => {:errors => {:login => ["unknown user"]}}
  end

  def update
    @srp_session = session.delete(:handshake)
    @user = @srp_session.authenticate!(params[:client_auth].hex)
    session[:user_id] = @user.id
    render :json => @srp_session
  rescue WRONG_PASSWORD
    session[:handshake] = nil
    render :json => {:errors => {"password" => ["wrong password"]}}
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end