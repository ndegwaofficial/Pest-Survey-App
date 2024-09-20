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
    SurveyField(fieldName: "Farm name or Farmer name", fieldType: "text"),
    SurveyField(fieldName: "County", fieldType: "text"),
    SurveyField(fieldName: "Subcounty", fieldType: "text"),
    SurveyField(fieldName: "Parish or Ward", fieldType: "text"),
    SurveyField(fieldName: "Village", fieldType: "text"),
    SurveyField(fieldName: "Nearest Town or Center", fieldType: "text"),
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
    SurveyField(fieldName: "Substrate Treatment", fieldType: "dropdown", options: [
      "None",
      "Heat",
      "Chemical"
    ]),
    SurveyField(fieldName: "Source of Substrate", fieldType: "dropdown", options: [
      "Local",
      "Import"
    ]),
    SurveyField(fieldName: "Crop Name e.g Maize, Beans...", fieldType: "text"),
    SurveyField(fieldName: "Variety", fieldType: "text"),
    SurveyField(fieldName: "Crop Intercropped With", fieldType: "text"),
    SurveyField(fieldName: "Sampling Unit Type", fieldType: "dropdown", options: [
      "Farm",
      "Garden",
      "Plot",
      "Bed",
      "Individual Plant",
      "Market",
      "Lot"
    ]),
    SurveyField(fieldName: "Sampling Unit e.g Unit 1, Unit 2", fieldType: "text"),
    SurveyField(fieldName: "Inspection Unit", fieldType: "dropdown", options: [
      "Whole Plant",
      "Plant Part",
      "Part",
    ]),
    SurveyField(fieldName: "Source of Planting Material", fieldType: "dropdown", options: [
      "Farmer Saved",
      "Market",
      "Government"
    ]),
    SurveyField(fieldName: "Source of Irrigation Water", fieldType: "dropdown", options: [
      "None",
      "River",
      "Borehole",
      "Lake",
      "Swamp",
      "Dam",
      "Roof"
    ]),
    SurveyField(fieldName: "Distance to water source (Km)", fieldType: "text"),
    SurveyField(fieldName: "Host Stage of Growth", fieldType: "dropdown", options: [
      "Seedling",
      "Vegetative",
      "Flowering",
      "Fruiting",
      "Scenescent",
    ]),
    SurveyField(fieldName: "Parts Affected", fieldType: "dropdown", options: [
      "Leaves",
      "Flower",
      "Fruits",
      "Stem",
      "Roots",
      "Tubers",
      "Seeds",
      "Pods"
    ]),
    SurveyField(fieldName: "Symptoms Observed", fieldType: "dropdown", options: [
      "Yellowing (Old Leaves)",
      "Discoloration (Young Leaves)",
      "Intense Yellowing (All Leaves)",
      "Dead Plant",
      "Wilting",
      "Necrosis",
      "Stunted",
      "Dark Sutures",
      "Water Soaked Lessions",
      "Soft Rots",
      "Leaf Spot",
      "Mosaic",
      "Deiback",
      "Root Rot",
      "Leaf Spot",
      "Canker",
      "Root Lessions",
      "Shoot Blight",
      "Leaf Blight",
      "Galls",
      "Fruit Spot",
      "Cracking"
    ]),
    SurveyField(fieldName: "Observation Status", fieldType: "dropdown", options: [
      "Negative",
      "Presumptive",
      "Positive"
    ]),
    SurveyField(fieldName: "Pest Incidence (% of affected hosts)", fieldType: "text"),
    SurveyField(fieldName: "Severity (%of host part affected)", fieldType: "text"),
    SurveyField(fieldName: "Distribution on host", fieldType: "text"),
    SurveyField(fieldName: "Symptoms Description", fieldType: "text"),
    SurveyField(fieldName: "Picture of Symptoms", fieldType: "text"),
    SurveyField(fieldName: "Vectors Present", fieldType: "dropdown", options: [
      "Yes",
      "No"
    ]),
    SurveyField(fieldName: "Vectors Observed", fieldType: "dropdown", options: [
      "Aphids",
      "Whiteflies",
      "Leafhoppers",
      "Thrips",
      "Mealybugs",
      "Psyllids",
      "Beetles",
      "Mites"
    ]),
    SurveyField(fieldName: "Picture of the vector", fieldType: "text"),
    SurveyField(fieldName: "List Other Symptoms (Separated by commas)", fieldType: "text"),
    SurveyField(fieldName: "Picture of any other pests/diseases observed", fieldType: "text"),
    SurveyField(fieldName: "Management Practices", fieldType: "dropdown", options: [
      "None",
      "Chemical",
      "Biological",
      "Physical",
      "Cultural",
    ]),
    SurveyField(fieldName: "Sample Taken", fieldType: "dropdown", options: [
      "Yes",
      "No"
    ]),
    SurveyField(fieldName: "Number of Samples", fieldType: "text"),
    SurveyField(fieldName: "Sample Code", fieldType: "text"),
    SurveyField(fieldName: "Any Other Remarks", fieldType: "text"),    
  ],




  "Detection": [
    SurveyField(fieldName: "Farm name or Farmer name", fieldType: "text"),
    SurveyField(fieldName: "County", fieldType: "text"),
    SurveyField(fieldName: "Subcounty", fieldType: "text"),
    SurveyField(fieldName: "Parish or Ward", fieldType: "text"),
    SurveyField(fieldName: "Village", fieldType: "text"),
    SurveyField(fieldName: "Nearest Town or Center", fieldType: "text"),
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
    SurveyField(fieldName: "Substrate Treatment", fieldType: "dropdown", options: [
      "None",
      "Heat",
      "Chemical"
    ]),
    SurveyField(fieldName: "Source of Substrate", fieldType: "dropdown", options: [
      "Local",
      "Import"
    ]),
    SurveyField(fieldName: "Crop Name e.g Maize, Beans...", fieldType: "text"),
    SurveyField(fieldName: "Variety", fieldType: "text"),
    SurveyField(fieldName: "Crop Intercropped With", fieldType: "text"),
    SurveyField(fieldName: "Sampling Unit Type", fieldType: "dropdown", options: [
      "Farm",
      "Garden",
      "Plot",
      "Bed",
      "Individual Plant",
      "Market",
      "Lot"
    ]),
    SurveyField(fieldName: "Sampling Unit e.g Unit 1, Unit 2", fieldType: "text"),
    SurveyField(fieldName: "Inspection Unit", fieldType: "dropdown", options: [
      "Whole Plant",
      "Plant Part",
      "Part",
    ]),
    SurveyField(fieldName: "Source of Planting Material", fieldType: "dropdown", options: [
      "Farmer Saved",
      "Market",
      "Government"
    ]),
    SurveyField(fieldName: "Source of Irrigation Water", fieldType: "dropdown", options: [
      "None",
      "River",
      "Borehole",
      "Lake",
      "Swamp",
      "Dam",
      "Roof"
    ]),
    SurveyField(fieldName: "Distance to water source (Km)", fieldType: "text"),
    SurveyField(fieldName: "Host Stage of Growth", fieldType: "dropdown", options: [
      "Seedling",
      "Vegetative",
      "Flowering",
      "Fruiting",
      "Scenescent",
    ]),
    SurveyField(fieldName: "Parts Affected", fieldType: "dropdown", options: [
      "Leaves",
      "Flower",
      "Fruits",
      "Stem",
      "Roots",
      "Tubers",
      "Seeds",
      "Pods"
    ]),
    SurveyField(fieldName: "Symptoms Observed", fieldType: "dropdown", options: [
      "Yellowing (Old Leaves)",
      "Discoloration (Young Leaves)",
      "Intense Yellowing (All Leaves)",
      "Dead Plant",
      "Wilting",
      "Necrosis",
      "Stunted",
      "Dark Sutures",
      "Water Soaked Lessions",
      "Soft Rots",
      "Leaf Spot",
      "Mosaic",
      "Deiback",
      "Root Rot",
      "Leaf Spot",
      "Canker",
      "Root Lessions",
      "Shoot Blight",
      "Leaf Blight",
      "Galls",
      "Fruit Spot",
      "Cracking"
    ]),
    SurveyField(fieldName: "Observation Status", fieldType: "dropdown", options: [
      "Negative",
      "Presumptive",
      "Positive"
    ]),
    SurveyField(fieldName: "Pest Incidence (% of affected hosts)", fieldType: "text"),
    SurveyField(fieldName: "Severity (%of host part affected)", fieldType: "text"),
    SurveyField(fieldName: "Distribution on host", fieldType: "text"),
    SurveyField(fieldName: "Symptoms Description", fieldType: "text"),
    SurveyField(fieldName: "Picture of Symptoms", fieldType: "text"),
    SurveyField(fieldName: "Vectors Present", fieldType: "dropdown", options: [
      "Yes",
      "No"
    ]),
    SurveyField(fieldName: "Vectors Observed", fieldType: "dropdown", options: [
      "Aphids",
      "Whiteflies",
      "Leafhoppers",
      "Thrips",
      "Mealybugs",
      "Psyllids",
      "Beetles",
      "Mites"
    ]),
    SurveyField(fieldName: "Picture of the vector", fieldType: "text"),
    SurveyField(fieldName: "List Other Symptoms (Separated by commas)", fieldType: "text"),
    SurveyField(fieldName: "Picture of any other pests/diseases observed", fieldType: "text"),
    SurveyField(fieldName: "Management Practices", fieldType: "dropdown", options: [
      "None",
      "Chemical",
      "Biological",
      "Physical",
      "Cultural",
    ]),
    SurveyField(fieldName: "Sample Taken", fieldType: "dropdown", options: [
      "Yes",
      "No"
    ]),
    SurveyField(fieldName: "Number of Samples", fieldType: "text"),
    SurveyField(fieldName: "Sample Code", fieldType: "text"),
    SurveyField(fieldName: "Any Other Remarks", fieldType: "text"),    
  ],


  "Monitoring": [
    SurveyField(fieldName: "Farm name or Farmer name", fieldType: "text"),
    SurveyField(fieldName: "County", fieldType: "text"),
    SurveyField(fieldName: "Subcounty", fieldType: "text"),
    SurveyField(fieldName: "Parish or Ward", fieldType: "text"),
    SurveyField(fieldName: "Village", fieldType: "text"),
    SurveyField(fieldName: "Nearest Town or Center", fieldType: "text"),
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
    SurveyField(fieldName: "Substrate Treatment", fieldType: "dropdown", options: [
      "None",
      "Heat",
      "Chemical"
    ]),
    SurveyField(fieldName: "Source of Substrate", fieldType: "dropdown", options: [
      "Local",
      "Import"
    ]),
    SurveyField(fieldName: "Crop Name e.g Maize, Beans...", fieldType: "text"),
    SurveyField(fieldName: "Variety", fieldType: "text"),
    SurveyField(fieldName: "Crop Intercropped With", fieldType: "text"),
    SurveyField(fieldName: "Sampling Unit Type", fieldType: "dropdown", options: [
      "Farm",
      "Garden",
      "Plot",
      "Bed",
      "Individual Plant",
      "Market",
      "Lot"
    ]),
    SurveyField(fieldName: "Sampling Unit e.g Unit 1, Unit 2", fieldType: "text"),
    SurveyField(fieldName: "Inspection Unit", fieldType: "dropdown", options: [
      "Whole Plant",
      "Plant Part",
      "Part",
    ]),
    SurveyField(fieldName: "Source of Planting Material", fieldType: "dropdown", options: [
      "Farmer Saved",
      "Market",
      "Government"
    ]),
    SurveyField(fieldName: "Source of Irrigation Water", fieldType: "dropdown", options: [
      "None",
      "River",
      "Borehole",
      "Lake",
      "Swamp",
      "Dam",
      "Roof"
    ]),
    SurveyField(fieldName: "Distance to water source (Km)", fieldType: "text"),
    SurveyField(fieldName: "Host Stage of Growth", fieldType: "dropdown", options: [
      "Seedling",
      "Vegetative",
      "Flowering",
      "Fruiting",
      "Scenescent",
    ]),
    SurveyField(fieldName: "Parts Affected", fieldType: "dropdown", options: [
      "Leaves",
      "Flower",
      "Fruits",
      "Stem",
      "Roots",
      "Tubers",
      "Seeds",
      "Pods"
    ]),
    SurveyField(fieldName: "Symptoms Observed", fieldType: "dropdown", options: [
      "Yellowing (Old Leaves)",
      "Discoloration (Young Leaves)",
      "Intense Yellowing (All Leaves)",
      "Dead Plant",
      "Wilting",
      "Necrosis",
      "Stunted",
      "Dark Sutures",
      "Water Soaked Lessions",
      "Soft Rots",
      "Leaf Spot",
      "Mosaic",
      "Deiback",
      "Root Rot",
      "Leaf Spot",
      "Canker",
      "Root Lessions",
      "Shoot Blight",
      "Leaf Blight",
      "Galls",
      "Fruit Spot",
      "Cracking"
    ]),
    SurveyField(fieldName: "Observation Status", fieldType: "dropdown", options: [
      "Negative",
      "Presumptive",
      "Positive"
    ]),
    SurveyField(fieldName: "Pest Incidence (% of affected hosts)", fieldType: "text"),
    SurveyField(fieldName: "Severity (%of host part affected)", fieldType: "text"),
    SurveyField(fieldName: "Distribution on host", fieldType: "text"),
    SurveyField(fieldName: "Symptoms Description", fieldType: "text"),
    SurveyField(fieldName: "Picture of Symptoms", fieldType: "text"),
    SurveyField(fieldName: "Vectors Present", fieldType: "dropdown", options: [
      "Yes",
      "No"
    ]),
    SurveyField(fieldName: "Vectors Observed", fieldType: "dropdown", options: [
      "Aphids",
      "Whiteflies",
      "Leafhoppers",
      "Thrips",
      "Mealybugs",
      "Psyllids",
      "Beetles",
      "Mites"
    ]),
    SurveyField(fieldName: "Picture of the vector", fieldType: "text"),
    SurveyField(fieldName: "List Other Symptoms (Separated by commas)", fieldType: "text"),
    SurveyField(fieldName: "Picture of any other pests/diseases observed", fieldType: "text"),
    SurveyField(fieldName: "Management Practices", fieldType: "dropdown", options: [
      "None",
      "Chemical",
      "Biological",
      "Physical",
      "Cultural",
    ]),
    SurveyField(fieldName: "Sample Taken", fieldType: "dropdown", options: [
      "Yes",
      "No"
    ]),
    SurveyField(fieldName: "Number of Samples", fieldType: "text"),
    SurveyField(fieldName: "Sample Code", fieldType: "text"),
    SurveyField(fieldName: "Any Other Remarks", fieldType: "text"),    
  ],

  "Delimiting": [
    SurveyField(fieldName: "Farm name or Farmer name", fieldType: "text"),
    SurveyField(fieldName: "County", fieldType: "text"),
    SurveyField(fieldName: "Subcounty", fieldType: "text"),
    SurveyField(fieldName: "Parish or Ward", fieldType: "text"),
    SurveyField(fieldName: "Village", fieldType: "text"),
    SurveyField(fieldName: "Nearest Town or Center", fieldType: "text"),
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
    SurveyField(fieldName: "Substrate Treatment", fieldType: "dropdown", options: [
      "None",
      "Heat",
      "Chemical"
    ]),
    SurveyField(fieldName: "Source of Substrate", fieldType: "dropdown", options: [
      "Local",
      "Import"
    ]),
    SurveyField(fieldName: "Crop Name e.g Maize, Beans...", fieldType: "text"),
    SurveyField(fieldName: "Variety", fieldType: "text"),
    SurveyField(fieldName: "Crop Intercropped With", fieldType: "text"),
    SurveyField(fieldName: "Sampling Unit Type", fieldType: "dropdown", options: [
      "Farm",
      "Garden",
      "Plot",
      "Bed",
      "Individual Plant",
      "Market",
      "Lot"
    ]),
    SurveyField(fieldName: "Sampling Unit e.g Unit 1, Unit 2", fieldType: "text"),
    SurveyField(fieldName: "Inspection Unit", fieldType: "dropdown", options: [
      "Whole Plant",
      "Plant Part",
      "Part",
    ]),
    SurveyField(fieldName: "Source of Planting Material", fieldType: "dropdown", options: [
      "Farmer Saved",
      "Market",
      "Government"
    ]),
    SurveyField(fieldName: "Source of Irrigation Water", fieldType: "dropdown", options: [
      "None",
      "River",
      "Borehole",
      "Lake",
      "Swamp",
      "Dam",
      "Roof"
    ]),
    SurveyField(fieldName: "Distance to water source (Km)", fieldType: "text"),
    SurveyField(fieldName: "Host Stage of Growth", fieldType: "dropdown", options: [
      "Seedling",
      "Vegetative",
      "Flowering",
      "Fruiting",
      "Scenescent",
    ]),
    SurveyField(fieldName: "Parts Affected", fieldType: "dropdown", options: [
      "Leaves",
      "Flower",
      "Fruits",
      "Stem",
      "Roots",
      "Tubers",
      "Seeds",
      "Pods"
    ]),
    SurveyField(fieldName: "Symptoms Observed", fieldType: "dropdown", options: [
      "Yellowing (Old Leaves)",
      "Discoloration (Young Leaves)",
      "Intense Yellowing (All Leaves)",
      "Dead Plant",
      "Wilting",
      "Necrosis",
      "Stunted",
      "Dark Sutures",
      "Water Soaked Lessions",
      "Soft Rots",
      "Leaf Spot",
      "Mosaic",
      "Deiback",
      "Root Rot",
      "Leaf Spot",
      "Canker",
      "Root Lessions",
      "Shoot Blight",
      "Leaf Blight",
      "Galls",
      "Fruit Spot",
      "Cracking"
    ]),
    SurveyField(fieldName: "Observation Status", fieldType: "dropdown", options: [
      "Negative",
      "Presumptive",
      "Positive"
    ]),
    SurveyField(fieldName: "Pest Incidence (% of affected hosts)", fieldType: "text"),
    SurveyField(fieldName: "Severity (%of host part affected)", fieldType: "text"),
    SurveyField(fieldName: "Distribution on host", fieldType: "text"),
    SurveyField(fieldName: "Symptoms Description", fieldType: "text"),
    SurveyField(fieldName: "Picture of Symptoms", fieldType: "text"),
    SurveyField(fieldName: "Vectors Present", fieldType: "dropdown", options: [
      "Yes",
      "No"
    ]),
    SurveyField(fieldName: "Vectors Observed", fieldType: "dropdown", options: [
      "Aphids",
      "Whiteflies",
      "Leafhoppers",
      "Thrips",
      "Mealybugs",
      "Psyllids",
      "Beetles",
      "Mites"
    ]),
    SurveyField(fieldName: "Picture of the vector", fieldType: "text"),
    SurveyField(fieldName: "List Other Symptoms (Separated by commas)", fieldType: "text"),
    SurveyField(fieldName: "Picture of any other pests/diseases observed", fieldType: "text"),
    SurveyField(fieldName: "Management Practices", fieldType: "dropdown", options: [
      "None",
      "Chemical",
      "Biological",
      "Physical",
      "Cultural",
    ]),
    SurveyField(fieldName: "Sample Taken", fieldType: "dropdown", options: [
      "Yes",
      "No"
    ]),
    SurveyField(fieldName: "Number of Samples", fieldType: "text"),
    SurveyField(fieldName: "Sample Code", fieldType: "text"),
    SurveyField(fieldName: "Any Other Remarks", fieldType: "text"),    
  ],
  
};
