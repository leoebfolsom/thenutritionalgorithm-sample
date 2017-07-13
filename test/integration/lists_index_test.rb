require 'test_helper'

class ListsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @list = lists(:weekend)
  end
  
  test "index including pagination" do
    get lists_path
    assert_template 'lists/index'
    assert_select 'div.pagination'
    List.paginate(page: 1).each do |list|
      assert_select 'a[href=?]', list_path(list), text: list.name
    end
  end
  
  test "index including pagination and delete links" do
    get lists_path
    assert_template 'lists/index'
    assert_select 'div.pagination'
    first_page_of_lists = List.paginate(page: 1)
    first_page_of_lists.each do |list|
      assert_select 'a[href=?]', list_path(list), text: list.name
      assert_select 'a[href=?]', list_path(list), text: 'delete'
    end
    assert_difference 'List.count', -1 do
      delete list_path(@list)
    end
  end
end