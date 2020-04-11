class ApplicationApiController < ActionController::API
  class NotAuthorized < StandardError; end

  rescue_from ApplicationApiController::NotAuthorized do |exception|
    render json: { error: 'Forbidden', message: exception.message }, status: 403
  end

  include ::ApplicationHelper

  before_action :authenticate_request
end
