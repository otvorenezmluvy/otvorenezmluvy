# http://stackoverflow.com/questions/6166064/i18n-pluralization/6166091#6166091
require "i18n/backend/pluralization"
I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)