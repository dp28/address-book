class PeopleController < ApplicationController
  before_action :validate_params, only: [:create, :update]
  before_action :ensure_person_exists, only: [:update, :destroy]

  def index
    render json: people.order(:name)
  end

  def create
    new_person_params = person_params.merge(contact_details: create_contact_details)
    new_person = Person.create(new_person_params)
    render json: new_person, status: :created
  end

  def update
    person.update person_params
    person.contact_details.update contact_details_params
    render json: person
  end

  def destroy
    render json: person.destroy
  end

  private

  def person_params
    params.require(:person).permit(:name)
  end

  def person
    return @person if defined? @person
    @person = Person.find_by id: params[:id]
  end

  def people
    if params[:matching_name].present?
      Person.where('lower(name) LIKE lower(?)', "%#{params[:matching_name]}%")
    else
      Person
    end
  end

  def validate_params
    if params[:person].nil? || params[:person][:name].nil?
      render_error key: 'missing_parameter', message: '"person.name" is required'
    end
  end

  def ensure_person_exists
    if person.nil?
      render_error(
        key:     'not_found',
        status:  :not_found,
        message: "No Person found with id #{params[:id]}"
      )
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
