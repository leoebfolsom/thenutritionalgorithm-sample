class UndoHardAdd
  
  def initialize(quantity)
    @quantity = quantity
  end
  
  def undo_hard_add

    @list = @quantity.list
    list_hard_add = @list.hard_add.split(",").map(&:to_i)
    list_hard_add_new = list_hard_add - [@quantity.id]
    list_hard_add_new = list_hard_add_new.uniq.join(",")<<","
    if list_hard_add_new == ","
      list_hard_add_new = ""
    end
    
    @list.update_attribute(:hard_add, list_hard_add_new)
    
  end
  
end