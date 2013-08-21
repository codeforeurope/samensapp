module ApplicationHelper
  def labeled_form_for(object, options = {}, &block)
    options[:builder] = LabeledFormBuilder
    form_for(object, options, &block)
  end

  def labeled_fields_for(object, options = {}, &block)
    options[:builder] = LabeledFormBuilder
    fields_for(object, options, &block)
  end

  def link_to_add_fields(name, f, association, options = {}, &block)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    options[:data] = {id: id, fields: fields.gsub("\n", "")}
    link_to(name, '#', options, &block)
  end


  def options_from_collection_for_select_with_data(collection, value_method, text_method, selected = nil, opt = {})
    data = opt.delete :data
    options = collection.map do |element|
      [element.send(text_method), element.send(value_method), data.map do |k, v|
        {"data-#{k}" => element.send(v)}
      end
      ].flatten
    end
    selected, disabled = extract_selected_and_disabled(selected)
    select_deselect = {}
    select_deselect[:selected] = extract_values_from_collection(collection, value_method, selected)
    select_deselect[:disabled] = extract_values_from_collection(collection, value_method, disabled)
    options_for_select(options, select_deselect)
  end

end
