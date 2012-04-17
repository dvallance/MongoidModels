require 'test_helper'

class DocumentTest < MiniTest::Unit::TestCase
  include MongoidModels

  def setup
  end

  def teardown
    #drops the test database collection when tests finish
    Document.collection.drop
    User.collection.drop
  end

  def test_setup
  end

  def test_validations_will_fail
    document = Document.new()
    refute document.valid?, "Document should have had validation failures"
    assert_equal 4, document.errors.count, "There should be 4 validation errors"
    refute_nil document.errors[:title]
    refute_nil document.errors[:markup]
    refute_nil document.errors[:content]
    refute_empty document.errors[:markup].select{|error| error =~ /accepted types/}
  end

  def test_validations_will_pass
    document = Document.new( { title: "tests", markup: "slim", content: "h1 Works" } )
    assert document.valid?, "Document should be valid"
  end

  def test_process_markup
    assert_equal Document.process_markup("slim", "h1 test"), "<h1>test</h1>"
    
    #ArgumentError is raised on unsported markup
    assert_raises ArgumentError do
      Document.process_markup "unkown_markup", ""
    end

    #Formatting error occurs with invalid markup content
    result = Document.process_markup "slim", "   h1 won't like leading spaces"
    assert_match "Problem processing markup", result, "There should have an issue with the supplied markup formatting"
  end

  def test_process_content_callback
    document = Document.new( { title: "test", markup: "slim", content: "h1 Works" } )
    assert document.valid?, "We need a valid document to test callbacks"
    assert document.save, "Document should save"
    assert_match document.processed_content, "<h1>Works</h1>", "Processed content should have the correct value"
  end

  def test_user_relationship
    document = Document.create( { title: "test", markup: "slim", content: "h1 Works" } )
    assert_nil document.user, "Should not have a parent user"
    user = User.create!(login: "a", password: "a")
    assert_instance_of User, user
    document.user = user
    document.save!
    assert_equal Document.find(document.id).user, User.first

  end

  
end
