import 'jobs.dart';

class CategoryModel {
  late List<Jobs> _jobs;

  CategoryModel({required List<Jobs> jobs}) {
    this._jobs = jobs;
  }

  List<Jobs> get jobs => _jobs;
  set jobs(List<Jobs> jobs) => _jobs = jobs;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['jobs'] != null) {
      _jobs = <Jobs>[];
      json['jobs'].forEach((v) {
        _jobs.add(new Jobs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._jobs != null) {
      data['jobs'] = this._jobs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
