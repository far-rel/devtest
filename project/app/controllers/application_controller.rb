class ApplicationController < ActionController::Base

  skip_before_action :verify_authenticity_token

  rescue_from ActionController::ParameterMissing, with: :parameter_error

  def authenticated?
    # Generate token: JWT.encode("", "SECRET", 'HS256')
    return false if request.headers['Authorization'].blank?
    jwt = request.headers['Authorization'].gsub('Bearer ', '')
    begin
      JWT.decode jwt, 'SECRET', true, algorithm: 'HS256'
      true
    rescue JWT::DecodeError
      false
    end
  end

  def authenticate!
    return if authenticated?
    render json: {error: 'Unauthenticated'}, status: 401
  end

  def parameter_error(error)
    render json: {error: error.to_s}, status: 400
  end

end
