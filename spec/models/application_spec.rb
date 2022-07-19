require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many(:pets)}
    it { should have_many(:pets).through(:pet_applications)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zipcode) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
  end

  describe 'methods' do
    it 'has_pets? returns true if application has pets associated' do
      application = Application.create!(name: 'John Doe', street_address: '123 apple street', city: 'Denver', state: 'CO', zipcode: '90210', description: 'we love pets', status: 'In Progress')
      application_2 = Application.create!(name: 'John Doe', street_address: '123 apple street', city: 'Denver', state: 'CO', zipcode: '90210', description: 'we love pets', status: 'In Progress')
      shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
      scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
      PetApplication.create!(pet: scooby, application: application)
      
      expect(application_2.has_pets?).to eq(false)
      expect(application.has_pets?).to eq(true)
    end

    it 'complete application sets the status to approved or rejected based on pet status' do
      application = Application.create!(name: 'John Doe', street_address: '123 apple street', city: 'Denver', state: 'CO', zipcode: '90210', description: 'we love pets', status: 'In Progress')
      application_2 = Application.create!(name: 'Jane Doe', street_address: 'pear street', city: 'NYC', state: 'NY', zipcode: '95732', description: 'I am lonely', status: 'In Progress')
      shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
      scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
      clifford = Pet.create!(name: 'Clifford', age: 1, breed: 'Red Dog', adoptable: true, shelter_id: shelter.id)
      rudolph = Pet.create!(name: 'Rudolph', age: 100, breed: 'Not Sure', adoptable: false, shelter_id: shelter.id)
  
      PetApplication.create!(pet: scooby, application: application, pet_status: 'approved')
      PetApplication.create!(pet: clifford, application: application, pet_status: 'rejected')
      PetApplication.create!(pet: rudolph, application: application_2, pet_status: 'approved')
      
      application.complete_application
      application_2.complete_application

      expect(application.status).to eq('Rejected')
      expect(application_2.status).to eq('Approved')
    end
  end
end
