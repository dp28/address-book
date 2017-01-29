class PeopleController < ApplicationController
  before_action :validate_params, only: [:create, :update]
  before_action :ensure_person_exists, only: [:update, :destroy]

  def index
    render json: people.order(:name).includes(:contact_details)
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
    param_missing = params[:person].nil? || params[:person][:name].nil?
    render_missing_parameter 'person.name' if param_missing
  end

  def ensure_person_exists
    render_not_found(model_class: Person) if person.nil?
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
