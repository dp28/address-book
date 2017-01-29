class OrganisationsController < ApplicationController
  before_action :validate_params, only: [:create, :update]
  before_action :ensure_organisation_exists, only: [:update, :destroy]

  def index
    render json: organisations.order(:name)
  end

  def create
    new_organisation_params = organisation_params.merge(contact_details: create_contact_details)
    new_organisation = Organisation.create(new_organisation_params)
    render json: new_organisation, status: :created
  end

  def update
    organisation.update organisation_params
    organisation.contact_details.update contact_details_params
    render json: organisation
  end

  def destroy
    render json: organisation.destroy
  end

  private

  def organisation_params
    params.require(:organisation).permit(:name)
  end

  def organisation
    return @organisation if defined? @organisation
    @organisation = Organisation.find_by id: params[:id]
  end

  def organisations
    if params[:matching_name].present?
      Organisation.where('lower(name) LIKE lower(?)', "%#{params[:matching_name]}%")
    else
      Organisation
    end
  end

  def validate_params
    if params[:organisation].nil? || params[:organisation][:name].nil?
      render_missing_parameter 'organisation.name'
    end
  end

  def ensure_organisation_exists
    render_not_found(model_class: Organisation) if organisation.nil?
  end

  def create_contact_details
    ContactDetails.create contact_details_params
  end

  def contact_details_params
    params[:organisation].fetch(:contact_details, {}).permit(*ContactDetails::USER_EDITABLE_PARAMS)
  end
end
