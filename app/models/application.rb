class Application < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :street_address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zipcode
  validates_presence_of :description
  validates_presence_of :status

  has_many :pet_applications
  has_many :pets, through: :pet_applications

  def has_pets?
    pets.length > 0
  end

  def complete_application
    statuses = pet_applications.pluck(:pet_status)
    if statuses.include?('rejected')
      update(status: 'Rejected')
    else
      update(status: 'Approved')
      pets.update_all(adoptable: false)
    end
  end
end
