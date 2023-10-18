import 'package:connie/objects/category.dart';
import 'package:flutter/material.dart';

class FinancialRecordsFilter {
  DateTimeRange dateRange;
  List<Category> categories;
  List<Type> recordTypes;

  FinancialRecordsFilter({
    required this.dateRange,
    required this.categories,
    required this.recordTypes,
  });
}
