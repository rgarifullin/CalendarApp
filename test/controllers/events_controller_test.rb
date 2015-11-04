require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    #@request.env["devise.mapping"] = Devise.mappings[:user]
    @user = users(:one)
    #sign_in @user#, event: :authentication#sign_in :users, @user
    #authenticate_user!(@user)
    #session[:user_id] = @user.id
    #post :create, :users, {user: {email: 'you@example.com', password: 'password'}}
  end

  test 'should be redirected if not authenticated' do
    get :index
    assert_redirected_to new_user_session_path
  end

  test 'should get index' do
    sign_in @user
    get :index, user_id: @user
    assert_response :success, @response.body
  end

  test 'should get new' do
    sign_in @user
    get :new, user_id: @user
    assert_response :success, @response.body
  end

  test 'should get edit' do
    sign_in @user
    get :edit, id: events(:first), user_id: users(:one)
    assert_response :success, @response.body
  end

  test 'should post create' do
    sign_in @user
    assert_difference('Event.count', 1) do
      post :create, event: { title: 'title example', recurrence: 'weekly',
                             schedule: { start_time: '2016.01.01' }
                           }, user_id: @user
    end
    assert_redirected_to user_events_path(@user)
    assert_not_nil Event.find_by(title: 'title example', recurrence: 'weekly')
  end

  test 'should patch update' do
    sign_in @user
    patch :update, event: { title: 'title example', recurrence: 'weekly',
                           schedule: { start_time: '2016.01.01' }},
                           id: events(:first), user_id: @user
    assert_redirected_to user_events_path(@user)
    assert_not_nil Event.find_by(title: 'title example', recurrence: 'weekly')
  end

  test 'should delete destroy' do
    sign_in @user
    @request.env['HTTP_REFERER'] = 'http://localhost'
    assert_difference('Event.count', -1) do
      delete :destroy, id: events(:first), user_id: @user
    end
  end

  test 'should get list' do
    sign_in @user
    get :list, user_id: @user
    assert_response :success, @response.body
    assert_not_nil assigns(:events)
  end
end
