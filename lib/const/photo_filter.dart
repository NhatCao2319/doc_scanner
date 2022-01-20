// ignore_for_file: constant_identifier_names

// GREYSCALE |VINTAGE | SWEET  | NOFILTER | MILK | PURPLE | WARM | SEPIA
class FilterModel {
  final List<double> filterMatrix;
  final String name;

  const FilterModel(this.filterMatrix, this.name);
}

const List<FilterModel> FILTERS = [
  FilterModel(NOFILTER, "No Filter"),
  FilterModel(GREYSCALE, "Grey Scale"),
  FilterModel(BLACKWHITE, "Black White"),
  FilterModel(VINTAGE, "Vintage"),
  FilterModel(SWEET, "Sweet"),
  FilterModel(MILK, "Milk"),
  FilterModel(PURPLE, "Purple"),
  FilterModel(WARM, "Warm"),
  FilterModel(SEPIA, "Sepia")
];

const WARM = [
  0.8,
  0.2,
  0.3,
  -0.1,
  0.1,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  3.0,
  -2.3,
  3.0,
  1.0,
  -0.1
];
const BLACKWHITE = [
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  1.0,
  0.0,
];
const SEPIA = [
  0.39,
  0.769,
  0.189,
  0.0,
  0.0,
  0.349,
  0.686,
  0.168,
  0.0,
  0.0,
  0.272,
  0.534,
  0.131,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0
];

const GREYSCALE = [
  0.2126,
  0.7152,
  0.0722,
  0.0,
  0.0,
  0.2126,
  0.7152,
  0.0722,
  0.0,
  0.0,
  0.2126,
  0.7152,
  0.0722,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0
];

const VINTAGE = [
  0.9,
  0.5,
  0.1,
  0.0,
  0.0,
  0.3,
  0.8,
  0.1,
  0.0,
  0.0,
  0.2,
  0.3,
  0.5,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0
];

const SWEET = [
  1.0,
  0.0,
  0.2,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0
];

const NOFILTER = [
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0
];
const MILK = [
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.6,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0
];

const PURPLE = [
  1.0,
  -0.2,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  -0.1,
  0.0,
  0.0,
  1.2,
  1.0,
  0.1,
  0.0,
  0.0,
  0.0,
  1.7,
  1.0,
  0.0
];
