# In RAILS 4.1.x this file is not needed anymore because everything should be loaded from secrets.yml but it does not???
Saapp::Application.config.secret_key_base = Rails.application.secrets.secret_key_base
