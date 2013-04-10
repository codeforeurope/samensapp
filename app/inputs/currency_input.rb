class CurrencyInput < SimpleForm::Inputs::Base
  def input
    content_tag(:div, :class => 'input-prepend') do
      content_tag(:span, '&#8364;'.html_safe, :class => 'add-on') +
        text_field(attribute_name, {:class => 'currency', :size => 7, :pattern =>"/^\d+(\.|\,)\d{2}$/"}.merge(input_html_options))
    end
  end
end