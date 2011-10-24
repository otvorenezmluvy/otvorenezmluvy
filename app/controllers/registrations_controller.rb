class RegistrationsController < Devise::RegistrationsController
  def create
    if verify_recaptcha
      super
    else
      build_resource
      clean_up_passwords(resource)
      flash[:alert] = I18n.t('recaptcha.errors.verification_failed')
      render_with_scope :new
    end
  end
end
