class PeopleController < ApplicationController
  before_action :validate_params

  def create
    person = Person.create(person_params)
    render json: person, status: :created
  end

  private

  def person_params
    params
      .require(:person)
      .permit(:name)
      .merge(contact_details: create_contact_details)
  end

  def validate_params
    if params[:person].nil? || params[:person][:name].nil?
      render_error key: 'missing_parameter', message: '"person.name" is required'
    end
  end

  def create_contact_details
    ContactDetails.create contact_details_params
  end

  def contact_details_params
    params[:person].fetch(:contact_details, {}).permit(*ContactDetails::USER_EDITABLE_PARAMS)
  end

  def render_error(key:, message:, status: :bad_request)
    render status: status, json: { key: key, message: message }
  end
end
