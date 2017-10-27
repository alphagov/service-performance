class APIController < ActionController::API
  include ActionController::MimeResponds

  include AuthenticatedController
end
