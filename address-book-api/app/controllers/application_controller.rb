class ApplicationController < ActionController::API

  def render_missing_parameter(parameter_name)
    render_error key: 'missing_parameter', message: "'#{parameter_name}' is required"
  end

  def render_not_found(model_class:, id: params[:id])
    render_error(
      key:     'not_found',
      status:  :not_found,
      message: "No #{model_class} found with id #{id}"
    )
  end

  def render_error(key:, message:, status: :bad_request)
    render status: status, json: { key: key, message: message }
  end
end
