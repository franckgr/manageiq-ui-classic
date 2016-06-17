class DialogFieldVisibilityService
  def initialize(
    auto_placement_visibility_service = AutoPlacementVisibilityService.new,
    number_of_vms_visibility_service = NumberOfVmsVisibilityService.new,
    service_template_fields_visibility_service = ServiceTemplateFieldsVisibilityService.new,
  )
    @auto_placement_visibility_service = auto_placement_visibility_service
    @number_of_vms_visibility_service = number_of_vms_visibility_service
    @service_template_fields_visibility_service = service_template_fields_visibility_service
  end

  def determine_visibility(options)
    field_names_to_hide = []
    field_names_to_show = []

    visibility_hash = @service_template_fields_visibility_service.determine_visibility(options[:service_template_request])
    field_names_to_hide += visibility_hash[:hide]

    visibility_hash = @auto_placement_visibility_service.determine_visibility(options[:auto_placement_enabled])
    field_names_to_hide += visibility_hash[:hide]
    field_names_to_show += visibility_hash[:show]

    visibility_hash = @number_of_vms_visibility_service.determine_visibility(options[:number_of_vms], options[:platform])
    field_names_to_hide += visibility_hash[:hide]
    field_names_to_show += visibility_hash[:show]
    {:hide => field_names_to_hide.flatten, :edit => field_names_to_show.flatten}
  end
end
