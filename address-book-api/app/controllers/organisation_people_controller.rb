class OrganisationPeopleController < ApplicationController
  before_action :ensure_organisation_exists
  before_action :validate_params, only: :create

  def index
    render json: organisation.people.order(:name)
  end

  def create
    person = Person.find_by id: params[:person_id]
    if person.nil?
      render_not_found model_class: Person
    else
      add_person person
    end
  end

  def destroy
    person = organisation.people.find_by id: params[:id]
    if person.nil?
      render_not_found model_class: Person
    else
      organisation.people.destroy(person)
      render_success
    end
  end

  private

  def ensure_organisation_exists
    render_not_found(model_class: Organisation) if organisation.nil?
  end

  def validate_params
    render_missing_parameter :person_id if params[:person_id].nil?
  end

  def add_person(person)
    if organisation.people.include? person
      render_success
    else
      organisation.people << person
      render_success status: :created
    end
  end

  def organisation
    return @organisation if defined? @organisation
    @organisation = Organisation.find_by id: params[:organisation_id]
  end

  def render_success(status: :ok)
    render json: { success: true }, status: status
  end
end
