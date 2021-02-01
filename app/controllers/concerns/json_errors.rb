# app/controllers/concerns/json_errors.rb

module JsonErrors
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError,                      with: :render_500
    rescue_from ActiveRecord::RecordNotFound,       with: :render_404
    rescue_from ActionController::ParameterMissing, with: :render_400
    rescue_from ActiveRecord::RecordInvalid,        with: :render_422


    def render_400(errors = 'required parameters invalid or missing')
      render_errors(errors, 400)
    end

    def render_401(errors = 'unauthorized access')
      render_errors(errors, 401)
    end

    def render_404(errors = 'not found')
      render_errors(errors, 404)
    end

    def render_422(errors = 'could not save data')
      render_errors(errors, 422)
    end

    def render_500(errors = 'internal server error')
      render_errors(errors, 500)
    end

    def render_not_logged_in
      render json: { logged_in: false }, status: :unauthorized
    end

    def render_status_not_found
      render json: { status: 'not found' }, status: 404
    end

    def render_status_unathorized
      render json: { status: 'unauthorized access' }, status: 401
    end


    def render_errors(errors, status = 400)
      data = {
        status: 'failed',
        errors: Array.wrap(errors)
      }

      render json: data , status: status
    end


    def render_object_errors(obj, status = 400)
      if obj.is_a?(ActiveRecord::Base)
        render_object_errors(obj.errors, status)
      elsif obj.is_a?(ActiveModel::Errors)
        render_errors(obj.full_messages, status)
      else
        render_errors(obj, status)
      end
    end

  end
end

