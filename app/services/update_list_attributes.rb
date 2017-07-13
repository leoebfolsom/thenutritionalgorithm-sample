class UpdateListAttributes

  def initialize(list_id)
    @list_id = list_id.to_i
  end

  def update_list_attributes
    list = List.find(@list_id)
    list.update_attributes({:total_calories => list.total_calories,
                            :total_carbohydrates => list.total_carbohydrates,
                            :total_fat => list.total_fat,
                            :total_protein => list.total_protein,
                            :total_sugar => list.total_sugar,
                            :total_fiber => list.total_fiber,
                            :total_vitamin_a => list.total_vitamin_a,
                            :total_vitamin_c => list.total_vitamin_c,
                            :total_iron => list.total_iron,
                            :total_calcium => list.total_calcium,
                            :total_sodium => list.total_sodium,
                            :total_price => list.total_price})

    list.save!
  end

end