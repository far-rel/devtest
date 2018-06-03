require 'test_helper'

class TargetGroupControllerTest < ActionDispatch::IntegrationTest

  test '#show when unauthenticated should get list wihtout secrets' do
    get '/target_groups/pl'
    assert_response :success
    target_group = JSON.parse(@response.body).first
    assert target_group['secret_code'].nil?
  end

  test '#show when authenticated should get list wihtout secrets' do
    get '/target_groups/pl', headers: {'Authorization' => "Bearer #{JWT.encode('', 'SECRET', 'HS256')}"}
    assert_response :success
    target_group = JSON.parse(@response.body).first
    refute target_group['secret_code'].nil?
  end
  
  test '#evaluate when unauthenticated returns error' do
    post '/evaluate_target'
    assert_response :unauthorized
  end
  
  test '#evaluate when authenticated without params returns error' do
    post '/evaluate_target', headers: {'Authorization' => "Bearer #{JWT.encode('', 'SECRET', 'HS256')}"}
    assert_response :bad_request
  end

  test '#evaluate when authenticated is successful' do
    mock = Minitest::Mock.new
    mock.expect :calculate, 100
    CalculatePriceCommand.stub :new, mock do
      post '/evaluate_target',
           headers: {'Authorization' => "Bearer #{JWT.encode('', 'SECRET', 'HS256')}"},
           params: {
             country_code: countries(:pl).code,
             target_group_id: target_groups(:parent).id,
             locations: [
               {id: locations(:krakow).id, panel_size: 100},
               {id: locations(:gdansk).id, panel_size: 200}
             ]
           }
      assert_response :success
    end
  end

end
