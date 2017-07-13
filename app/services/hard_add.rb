class HardAdd

  def initialize(quantity_id)
    @quantity_id = quantity_id
  end
  
  def hard_add
    quantity = Quantity.find(@quantity_id)
    @list = quantity.list
    list_hard_add = @list.hard_add.split(",").map(&:to_i)
    list_hard_add_new = list_hard_add + [@quantity_id]
    list_hard_add_new = list_hard_add_new.uniq.join(",")<<","
    @list.update_attribute(:hard_add, list_hard_add_new)
  end

end