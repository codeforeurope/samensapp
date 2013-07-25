module RoomFieldsHelper
  ActionView::Helpers::FormBuilder.class_eval do
    def room_fields_for(record_name, *args, &proc)
      raise ArgumentError, "Missing block" unless block_given?
      @index = @index ? @index + 1 : 1
      object_name = "#{@object_name}[event_rooms_attributes][#{@index}]"
      object = @object.event_rooms.find_by_id()
      @template.concat @template.hidden_field_tag("#{object_name}[id]", object ? object.id : "")
      #@template.concat @template.hidden_field_tag("#{object_name}[locale]", locale)
      if @template.respond_to? :simple_fields_for
        @template.simple_fields_for(object_name, object, *args, &proc)
      else
        @template.fields_for(object_name, object, *args, &proc)
      end
    end
  end
end


