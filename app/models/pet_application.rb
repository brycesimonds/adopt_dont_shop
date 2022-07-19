class PetApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  # def completed? 
  #   if select(:pet_status).include?(nill)
  #     return false
  #   else 
  #     return true
  #   end
  # end
end
