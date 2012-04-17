require 'test_helper'

class UserTest < MiniTest::Unit::TestCase
  include MongoidModels

  def setup
  end

  def teardown
    #drops the test database collection when tests finish
    User.collection.drop
    Document.collection.drop
  end

  def test_validations_will_fail
    user = User.new()
    refute user.valid?, "User should have had validation failures"
    assert_equal 2, user.errors.count, "There should be 2 validation errors"
    refute_nil user.errors[:login]
    refute_nil user.errors[:password]
  end

  def test_validations_will_pass
    user = User.new( { login: "login", :password => "password"} )
    assert user.valid?, "User should be valid"
  end

  def test_before_save_callback
    user = User.new( { login: "login", :password => "password"} )
    assert user.valid?, "We need a valid user to test callbacks"
    assert user.save, "User should save"
    refute_equal "password", user.password, "Password should have been encrypted before saving"
  end

  def test_authenticate
    user = User.create( { login: "login", :password => "password"} )
    assert_instance_of User, user 
    refute_equal user, User.authenticate("login", "wrong_password")
    assert_equal user, User.authenticate("login", "password")
  end

  def test_document_relationship
    user = User.create( { login: "login", :password => "password"} )
    doc1 = user.documents.create! title: "a", markup: "slim", content: "h1 a"
    assert_raises Mongoid::Errors::Validations do
      user.documents.create! 
    end
    doc2 = user.documents.create! title: "b", markup: "slim", content: "h1 a"
    assert_includes Document.all.to_ary, doc1, "Doc1 should have been created"
    assert_includes Document.all.to_ary, doc2, "Doc2 should have been created"

    assert user.destroy, "Should be able to destroy our test user"
    assert_empty User.all.to_ary, "Should be no user"
    assert_empty Document.all.to_ary, "Destroying user should destroy dependent documents"

  end
  
end
