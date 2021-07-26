import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants/constants.dart';
import 'package:job_listing_flutter/provider/CategoryProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CategoryProvider(),
      child: MaterialApp(
        title: 'JobsListing',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isClicked = false;
  var searchJobs;
  var jobsByCategory;
  TextEditingController searchController = TextEditingController();

  Future getJobs() async {
    var response = await http
        .get(Uri.parse("https://remotive.io/api/remote-jobs/categories"));
    setState(() {
      searchJobs = jsonDecode(response.body.toString());
    });
  }

  void customLaunch(url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      print(' could not launch $url');
    }
  }

  Future<void> getJobsByCategory(String category) async {
    var response = await http.get(
        Uri.parse("https://remotive.io/api/remote-jobs?category=$category"));
    setState(() {
      jobsByCategory = jsonDecode(response.body.toString());
    });
  }

  Future<void> searchJobsText() async {
    var response = await http.get(Uri.parse(
        "https://remotive.io/api/remote-jobs?category=${searchController.text}"));
    setState(() {
      jobsByCategory = jsonDecode(response.body.toString());
    });
  }

  @override
  void initState() {
    getJobs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints.expand(height: 230),
              decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [lightBlueIsh, lightGreen],
                      begin: const FractionalOffset(1.0, 1.0),
                      end: const FractionalOffset(0.2, 0.2),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(50, 70, 50, 10),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          TextField(
                            keyboardType: TextInputType.name,
                            autofocus: false,
                            focusNode: FocusScopeNode(),
                            cursorColor: searchTextColor,
                            decoration: new InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 25,
                                  color: primaryColor,
                                ),
                                border: new OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(55.0),
                                  ),
                                ),
                                filled: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle:
                                    new TextStyle(color: searchTextColor),
                                labelStyle: new TextStyle(color: primaryColor),
                                hintText: 'Search Jobs Here',
                                fillColor: shadeColor),
                            controller: searchController,
                            onChanged: (text) {},
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Job Categories',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FutureBuilder(
                    builder: (context, snapshot) {
                      if (searchJobs != null) {
                        return Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: searchJobs['jobs'].length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      getJobsByCategory(
                                          searchJobs['jobs'][index]['slug']);
                                      setState(() {
                                        isClicked = true;
                                      });
                                    },
                                    child: Text(
                                      searchJobs['jobs'][index]['name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      primary: Colors.black,
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              ),
            ),
            FutureBuilder(builder: (context, snapshot) {
              if (jobsByCategory != null) {
                return Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: jobsByCategory['jobs'].length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: lightGreen,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      jobsByCategory['jobs'][index]['title'],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "Company Name :" +
                                          jobsByCategory['jobs'][index]
                                              ['company_name'],
                                      style: TextStyle(color: Colors.black)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "Category :" +
                                          jobsByCategory['jobs'][index]
                                              ['category'],
                                      style: TextStyle(color: Colors.black)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Location :" +
                                              jobsByCategory['jobs'][index][
                                                  'candidate_required_location'],
                                          style:
                                              TextStyle(color: Colors.black)),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            customLaunch(jobsByCategory['jobs']
                                                [index]['url']);
                                          });
                                        },
                                        child: Text(
                                          'Click for more info',
                                          style: TextStyle(color: lightBlueIsh),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else {
                if (isClicked) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Text("Please Click Any category");
                }
              }
            }),
          ],
        ),
      ),
    );
  }
}
