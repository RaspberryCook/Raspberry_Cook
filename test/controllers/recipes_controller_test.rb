require 'test_helper'
require "authlogic/test_case" # include at the top of test_helper.rb

class RecipesControllerTest < ActionController::TestCase
  setup do
    @recipe = recipes(:one)
  end

  setup :activate_authlogic

  test "should get index" do
    get :index
    assert_response :success
  end


  test "should be redirect to signin_path on  get new" do
    get :new
    assert_redirected_to signup_path
  end


  test "should get new" do
    UserSession.create(users(:ben))
    get :new
    assert_response :success
  end


  test "should not create recipe because no one is connected" do
    assert_no_difference('Recipe.count') do
      post :create, recipe: { name: "hello" }
    end
  end


  test "should create a recipe" do
    UserSession.create(users(:ben))
    assert_difference('Recipe.count', 1) do
      post :create, recipe: { name: "hello" }
    end
  end


  test "should be redirected to signup path when non-logged user want create a recipe" do
    get :create
    assert_redirected_to signup_path
  end


  test "should show recipe" do
    get :show, id: @recipe
    assert_response :success
  end


  test "should be redirect to signin_path on  Recipes#Edit" do
    get :edit, id: @recipe
    assert_redirected_to signup_path
  end


  test "should edit recipe" do
    #try to edit as me
    UserSession.create(users(:me))
    get :edit, id: @recipe
    assert_response :success
  end


  test "should not edit recipe because current_user is not the author" do
    #try to edit as me
    UserSession.create(users(:ben))
    get :edit, id: @recipe
    assert_redirected_to  '/' 
  end


  test "should update recipe" do
    UserSession.create(users(:me))
    patch :update, id: @recipe, recipe: { name: 'hello' }
    assert_redirected_to recipe_path(@recipe)
  end

  test "should not update recipe because current_user is not the author" do
    UserSession.create(users(:ben))
    patch :update, id: @recipe, recipe: { name: 'hello' }
    assert_redirected_to '/' 
  end


  test "should destroy recipe" do
    UserSession.create(users(:me))
    assert_difference('Recipe.count', -1) do
      delete :destroy, id: @recipe
    end
  end


  test "should not destroy recipe because current_user is not the author" do
    UserSession.create(users(:ben))
    assert_no_difference('Recipe.count') do
      delete :destroy, id: @recipe
    end
  end


end
