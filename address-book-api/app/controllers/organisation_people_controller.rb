class OrganisationPeopleController < ApplicationController
  before_action :ensure_organisation_exists
  before_action :validate_params, except: :index
  before_action :ensure_person_exists, except: :index

  def index
    render json: organisation.people.order(:name)
  end

  def create
    if organisation.people.include? person
      render_success
    else
      organisation.people << person
      render_success status: :created
    end
  end

  private

  def ensure_organisation_exists
    render_not_found(model_class: Organisation) if organisation.nil?
  end

  def ensure_person_exists
    render_not_found(model_class: Person) if person.nil?
  end

  def validate_params
    render_missing_parameter :person_id if params[:person_id].nil?
  end

  def organisation
    return @organisation if defined? @organisation
    @organisation = Organisation.find_by id: params[:organisation_id]
  end

  def person
    return @person if defined? @person
    @person = Person.find_by id: params[:person_id]
  end

  def render_success(status: :ok)
    render json: { success: true }, status: status
  end
end
