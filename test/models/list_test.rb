require 'test_helper'

class ListTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:leo)
    @list = @user.lists.build(days: 4, 
                    name: "groceries", 
                    age: 26, 
                    gender: "m", 
                    store: "Kwik-E-Mart",
                    max_price: 100,
                    user_id: @user.id
                    )
  end

  test "should be valid" do
    assert @list.valid?
  end
  
  test "list name should be present" do
    @list.name = "    "
    assert_not @list.valid?
  end
  
  test "days should be present" do
    @list.days = " "
    assert_not @list.valid?
  end
  
  test "gender should be present" do
    @list.days = ""
    assert_not @list.valid?
  end
  
  test "store should be present" do
    @list.store = ""
    assert_not @list.valid?
  end
  
  test "max price should be present" do
    @list.store = ""
    assert_not @list.valid?
  end
  
  test "name should not be too long" do
    @list.name = "a" * 141
    assert_not @list.valid?
  end
  
  test "names should be unique" do
    duplicate_list = @list.dup
    duplicate_list.name = @list.name.upcase
    @list.save
    assert_not duplicate_list.valid?
  end
  
  test "user id should be present" do
      @list.user_id = nil
      assert_not @list.valid?
  end

end