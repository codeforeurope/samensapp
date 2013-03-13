module ApplicationHelper
  def labeled_form_for(object, options = {}, &block)
    options[:builder] = LabeledFormBuilder
    form_for(object, options, &block)
  end
  def labeled_fields_for(object, options = {}, &block)
    options[:builder] = LabeledFormBuilder
    fields_for(object, options, &block)
  end
end
