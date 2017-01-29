class OrganisationPeopleController < ApplicationController
  before_action :ensure_organisation_exists

  def index
    render json: organisation.people.order(:name)
  end

  private

  def organisation
    return @organisation if defined? @organisation
    @organisation = Organisation.find_by id: params[:organisation_id]
  end

  def ensure_organisation_exists
    render_not_found(model_class: Organisation) if organisation.nil?
  end
end
