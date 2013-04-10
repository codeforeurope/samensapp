# config/initializers/simple_form/delegates.rb
module SimpleForm
  module Inputs
    module Delegates
      delegate :content_tag, :to => :template
      delegate :text_field, :to => :@builder
      delegate :number_field, :to => :@builder
    end
  end
end
SimpleForm::Inputs::Base.send(:include, SimpleForm::Inputs::Delegates)