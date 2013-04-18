class ErrorsController < ApplicationController
  def invalid_route
    render_404
  end
end
