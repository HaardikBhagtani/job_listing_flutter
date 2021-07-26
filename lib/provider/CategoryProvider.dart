import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:job_listing_flutter/models/jobs.dart';
import 'package:job_listing_flutter/models/jobs_categories.dart';
import 'package:http/http.dart' as http;

class CategoryProvider extends ChangeNotifier {
  bool isLoading = true;

  CategoryModel _category = new CategoryModel(jobs: []);
  List<Jobs> list = [];

  CategoryProvider() {
    _category.jobs = list;
  }

  void setData(CategoryModel category) {
    _category = category;
    isLoading = false;
  }

  CategoryModel getData() {
    return _category;
  }

  Future<CategoryModel> getCategory() async {
    var response = await http
        .get(Uri.parse("https://remotive.io/api/remote-jobs/categories"));
    final Map<String, dynamic> parsed = json.decode(response.body);
    CategoryModel _category = CategoryModel.fromJson(parsed);

    return _category;
  }
}
