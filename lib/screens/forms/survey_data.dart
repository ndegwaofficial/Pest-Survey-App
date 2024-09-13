class SurveyField {
  final String fieldName;
  final String fieldType; // text, dropdown, etc.
  final List<String>? options; // For dropdown or radio buttons
  bool isVisible; // Control visibility of the field

  SurveyField({
    required this.fieldName,
    required this.fieldType,
    this.options,
    this.isVisible = true,
  });
}

final Map<String, List<SurveyField>> surveyFields = {
  "General": [
    SurveyField(fieldName: "Farm or Farmer name", fieldType: "text"),
    SurveyField(fieldName: "County", fieldType: "text"),
    SurveyField(fieldName: "Substrate", fieldType: "dropdown", options: [
      "Cocopeat",
      "PeatMoss",
      "Vermiculite",
      "Perlite",
      "Clay soil",
      "Loam soil",
      "Sandy soil",
      "Pumice"
    ]),
  ],
  "Detection": [
    SurveyField(fieldName: "Pest Name", fieldType: "text"),
    SurveyField(fieldName: "Host stage of growth", fieldType: "dropdown", options: [
      "Seedling",
      "Vegetative",
      "Flowering",
      "Fruiting",
      "Senescent",
    ]),
  ],
  "Monitoring": [
    SurveyField(fieldName: "Crop Name", fieldType: "text"),
    SurveyField(fieldName: "Management Practices", fieldType: "dropdown", options: [
      "None",
      "Chemical",
      "Biological",
      "Physical",
      "Cultural"
    ]),
  ],
};
