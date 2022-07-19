class PetApplicationsController < ApplicationController
    def create
        pet = Pet.find(params[:pet_id])
        application = Application.find(params[:application_id])
        pet_application_association = PetApplication.create!(pet: pet, application: application)
        redirect_to "/applications/#{application.id}"
    end

    def update
        app = Application.find(params[:application_id])
        pet_application = app.pet_applications.find_by(pet_id: params[:pet_id].to_i)
        pet_application.update(pet_status: params[:pet_status])
        app.complete_application unless app.pet_applications.pluck(:pet_status).include?(nil)

        redirect_to "/admin/applications/#{app.id}"
    end
end
