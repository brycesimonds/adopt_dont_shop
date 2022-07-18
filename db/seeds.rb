require 'faker'

5.times do 
    Application.create!(
        name: Faker::Name.name, 
        street_address: Faker::Address.street_address, 
        city: Faker::Address.city, 
        state: Faker::Address.state_abbr,
        zipcode: Faker::Address.zip, 
        description: Faker::Hipster.sentence, 
        status: 'In Progress'
    )
end

5.times do
    Shelter.create!(
        name: Faker::Company.name, 
        city: Faker::Address.city,
        foster_program: Faker::Boolean.boolean,
        rank: Faker::Number.within(range: 1..10)
    )
end

20.times do
    Pet.create!(
        name: Faker::Hipster.word, 
        age: Faker::Number.within(range: 1..10), 
        breed: Faker::Creature::Animal.name, 
        adoptable: true, 
        shelter_id: rand(1..5)
    )
end

pet_application_1 = PetApplication.create!(pet: Pet.all.sample, application: Application.first)
pet_application_2 = PetApplication.create!(pet: Pet.all.sample, application: Application.first)
pet_application_3 = PetApplication.create!(pet: Pet.all.sample, application: Application.second)
pet_application_4 = PetApplication.create!(pet: Pet.all.sample, application: Application.third)