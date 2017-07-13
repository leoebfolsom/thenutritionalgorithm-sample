require 'test_helper'

class ListsCreateTest < ActionDispatch::IntegrationTest

  test "invalid list creation information" do
    get addlist_path
    assert_no_difference 'List.count' do
      post lists_path, list: { days:  "",
                               name: "a" * 141,
                               age: "",
                               gender: "",
                               store: "",
                               max_price: ""
                              }
    end
    assert_template 'lists/new'
  end
  
  test "valid list creation information" do
    get addlist_path
    assert_difference 'List.count', 1 do
      post_via_redirect lists_path, list: {
                                            days: 2,
                                            name: "example list",
                                            age: 26,
                                            gender: "m",
                                            store: "Kwik-E-Mart",
                                            max_price: 1.00
                                          }
    end
    assert_template 'lists/show'
  end
  
end