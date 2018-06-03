require 'test_helper'

class LocationsControllerTest < ActionDispatch::IntegrationTest

  test "#show when unauthenticated should get list wihtout secrets" do
    get '/locations/pl'
    assert_response :success
    location = JSON.parse(@response.body).first
    assert location["secret_code"].nil?
  end

  test "#show when authenticated should get list wihtout secrets" do
    get '/locations/pl', headers: {"Authorization" => "Bearer #{JWT.encode("", "SECRET", 'HS256')}"}
    assert_response :success
    location = JSON.parse(@response.body).first
    refute location["secret_code"].nil?
  end

end
