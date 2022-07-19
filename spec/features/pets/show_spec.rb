require 'rails_helper'

RSpec.describe 'the shelter show' do
  it "shows the shelter and all it's attributes" do
    shelter = Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
    pet = Pet.create(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)

    visit "/pets/#{pet.id}"

    expect(page).to have_content(pet.name)
    expect(page).to have_content(pet.age)
    expect(page).to have_content(pet.adoptable)
    expect(page).to have_content(pet.breed)
    expect(page).to have_content(pet.shelter_name)
  end

  it "allows the user to delete a pet" do
    shelter = Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
    pet = Pet.create(name: 'Scrappy', age: 1, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)

    visit "/pets/#{pet.id}"

    click_on("Delete #{pet.name}")

    expect(page).to have_current_path('/pets')
    expect(page).to_not have_content(pet.name)
  end

  it 'approved applications makes pets unadoptable' do
    application = Application.create!(name: 'John Doe', street_address: '123 apple street', city: 'Denver', state: 'CO', zipcode: '90210', description: 'we love pets', status: 'In Progress')
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
    scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    clifford = Pet.create!(name: 'Clifford', age: 1, breed: 'Red Dog', adoptable: true, shelter_id: shelter.id)

    PetApplication.create!(pet: scooby, application: application)
    PetApplication.create!(pet: clifford, application: application)

    visit "/admin/applications/#{application.id}"

    within "#pets-#{scooby.id}" do 
      click_on("Approve")
    end  

    within "#pets-#{clifford.id}" do 
      click_on("Approve")
    end 
    
    visit "/pets/#{scooby.id}"
    expect(page).to have_content("false")
    expect(page).to_not have_content("true")

    visit "/pets/#{clifford.id}"
    expect(page).to have_content("false")
    expect(page).to_not have_content("true")
  end
end
