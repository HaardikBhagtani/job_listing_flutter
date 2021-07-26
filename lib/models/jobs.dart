class Jobs {
  late int id;
  late String url;
  late String title;
  late String companyName;
  late String category;
  late List<String> tags;
  late String jobType;
  late String publicationDate;
  late String candidateRequiredLocation;
  late String salary;
  late String description;
  late String companyLogoUrl;

  Jobs(
      {required this.id,
      required this.url,
      required this.title,
      required this.companyName,
      required this.category,
      required this.tags,
      required this.jobType,
      required this.publicationDate,
      required this.candidateRequiredLocation,
      required this.salary,
      required this.description,
      required this.companyLogoUrl});

  Jobs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    title = json['title'];
    companyName = json['company_name'];
    category = json['category'];
    if (json['tags'] != null) {
      tags = <String>[];
      json['tags'].forEach((v) {
        tags.add(v.toString());
      });
    }
    jobType = json['job_type'];
    publicationDate = json['publication_date'];
    candidateRequiredLocation = json['candidate_required_location'];
    salary = json['salary'];
    description = json['description'];
    companyLogoUrl = json['company_logo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['title'] = this.title;
    data['company_name'] = this.companyName;
    data['category'] = this.category;
    if (this.tags != null) {
      data['tags'] = this.tags.toList();
    }
    data['job_type'] = this.jobType;
    data['publication_date'] = this.publicationDate;
    data['candidate_required_location'] = this.candidateRequiredLocation;
    data['salary'] = this.salary;
    data['description'] = this.description;
    data['company_logo_url'] = this.companyLogoUrl;
    return data;
  }
}
