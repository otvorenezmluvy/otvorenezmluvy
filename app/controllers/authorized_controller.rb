class AuthorizedController < ApplicationController
  before_filter :authenticate_user!
  check_authorization
  load_and_authorize_resource
end