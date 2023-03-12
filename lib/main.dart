//Made By Vaibhav Tiwari(102117089)
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var db = FirebaseFirestore.instance;
String firstName = "";
String lastName = "";
String rollNumber = "";
String allocatedHostel="";
String desiredHostel="";
String contactNumber="";
String  resultName="";
int  lstNamelength=0;
var lstName = List.generate(3000, (_) => "",growable: true);
var lstContact = List.generate(3000, (_) => "",growable: true);
var resultContact="";


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

const String myhomepageRoute = '/';
const String myprofileRoute = 'profile';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case myhomepageRoute:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
      case myprofileRoute:
        return MaterialPageRoute(builder: (_) => MyProfilePage());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('404 Not found')),
            ));
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Hostel Swapper",
        home: MyHomePage(),
        onGenerateRoute: Router.generateRoute,
        initialRoute: myhomepageRoute);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();


  var measure;

  void _submit() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to close the pop up
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm your information'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Full name:",
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(firstName + " " + lastName),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Roll Number:",
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("$rollNumber "),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Allocated Hostel:",
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(allocatedHostel),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Desired Hostel:",
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(desiredHostel),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Contact Number:",
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(contactNumber),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  child: const Text('Show Results'),
                    onPressed: () async {
                      String message;

                      try {
                        // Get a reference to the `feedback` collection
                        final collection =
                        FirebaseFirestore.instance.collection('feedback');

                        // Write the server's timestamp and the user's feedback
                        await collection.doc().set({
                          'full-name': "$firstName $lastName",
                          'contact': contactNumber,
                          'allocated':allocatedHostel,
                          'desired':desiredHostel,
                          'roll-no':rollNumber,
                        });

                        message = 'Feedback sent successfully';
                      } catch (e) {
                        message = 'Error when sending feedback';
                      }

                      await db.collection("feedback").where("allocated", isEqualTo: desiredHostel).where("desired", isEqualTo: allocatedHostel).get().then( (res) async {
                        int c=0;
                        res.docs.forEach((element) {
                          Map<String, dynamic> documentFields = element.data();
                          resultName=documentFields['full-name'];
                          resultContact=documentFields['contact'];
                          lstName[c]=resultName;
                          lstContact[c]=resultContact;
                          c++;
                        });
                      });
                      Navigator.pop(context);
                     Navigator.push(
                     context,
                     MaterialPageRoute(
                     builder: (context) => const MyResult(),
                      ));
                     lstNamelength=0;
                     lstName.forEach((element) {if(element!="") lstNamelength++;});
                    },
                  // onPressed: () {
                  //   Navigator.of(context).pop(); // Close the dialog
                  //   FocusScope.of(context)
                  //       .unfocus(); // Unfocus the last selected input field
                  //   _formKey.currentState?.reset(); // Empty the form fields
                  // },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Hostel Swapper"),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.account_circle, size: 32.0),
        //     tooltip: 'Profile',
        //     onPressed: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => MyProfilePage(),
        //           ));
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Align(
              alignment: Alignment.topLeft,
              child: Text("Enter your details",
                  style: TextStyle(
                    fontSize: 24,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'First Name',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                          BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    onFieldSubmitted: (value) {
                      setState(() {
                        firstName = value.capitalize();
                        // firstNameList.add(firstName);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        firstName = value.capitalize();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 3) {
                        return 'First Name must contain at least 3 characters';
                      } else if (value.contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                        return 'First Name cannot contain special characters';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Last Name',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                          BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 3) {
                        return 'Last Name must contain at least 3 characters';
                      } else if (value.contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                        return 'Last Name cannot contain special characters';
                      }
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        lastName = value.capitalize();
                        // lastNameList.add(lastName);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        lastName = value.capitalize();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Roll Number',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                          BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.contains(RegExp(r'^[a-zA-Z\-]'))) {
                        return 'Use only numbers!';
                      }
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        rollNumber = value;
                        // bodyTempList.add(bodyTemp);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        rollNumber = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                            BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      items: [
                        const DropdownMenuItem(
                          child: Text("A"),
                          value: "A",
                        ),
                        const DropdownMenuItem(
                          child: Text("B"),
                          value: "B",
                        ),
                        const DropdownMenuItem(
                          child: Text("C"),
                          value: "C",
                        ),
                        const DropdownMenuItem(
                          child: Text("G"),
                          value: "G",
                        ),
                        const DropdownMenuItem(
                          child: Text("H"),
                          value: "H",
                        ),
                        const DropdownMenuItem(
                          child: Text("I"),
                          value: "I",
                        ),
                        const DropdownMenuItem(
                          child: Text("J"),
                          value: "J",
                        ),
                        const DropdownMenuItem(
                          child: Text("K"),
                          value: "K",
                        ),
                        const DropdownMenuItem(
                          child: Text("L"),
                          value: "L",
                        ),
                        const DropdownMenuItem(
                          child: Text("M"),
                          value: "M",
                        ),
                        const DropdownMenuItem(
                          child: Text("N"),
                          value: "N",
                        ),
                        const DropdownMenuItem(
                          child: Text("O"),
                          value: "O",
                        ),
                        const DropdownMenuItem(
                          child: Text("P"),
                          value: "P",
                        ),
                        const DropdownMenuItem(
                          child: Text("Q"),
                          value: "Q",
                        )
                      ],
                      hint: const Text("Select your allocated hostel"),
                      onChanged: (value) {
                        setState(() {
                          measure = value;
                          allocatedHostel=value.toString();
                          print(allocatedHostel);
                          // measureList.add(measure);
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          measure = value;
                          allocatedHostel=value.toString();
                        });
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                            BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      items: [
                        const DropdownMenuItem(
                          child: Text("A"),
                          value: "A",
                        ),
                        const DropdownMenuItem(
                          child: Text("B"),
                          value: "B",
                        ),
                        const DropdownMenuItem(
                          child: Text("C"),
                          value: "C",
                        ),
                        const DropdownMenuItem(
                          child: Text("G"),
                          value: "G",
                        ),
                        const DropdownMenuItem(
                          child: Text("H"),
                          value: "H",
                        ),
                        const DropdownMenuItem(
                          child: Text("I"),
                          value: "I",
                        ),
                        const DropdownMenuItem(
                          child: Text("J"),
                          value: "J",
                        ),
                        const DropdownMenuItem(
                          child: Text("K"),
                          value: "K",
                        ),
                        const DropdownMenuItem(
                          child: Text("L"),
                          value: "L",
                        ),
                        const DropdownMenuItem(
                          child: Text("M"),
                          value: "M",
                        ),
                        const DropdownMenuItem(
                          child: Text("N"),
                          value: "N",
                        ),
                        const DropdownMenuItem(
                          child: Text("O"),
                          value: "O",
                        ),
                        const DropdownMenuItem(
                          child: Text("P"),
                          value: "P",
                        ),
                        const DropdownMenuItem(
                          child: Text("Q"),
                          value: "Q",
                        )
                      ],
                      hint: const Text("Select your Desired hostel"),
                      onChanged: (value) {
                        setState(() {
                          measure = value;
                          desiredHostel=value.toString();
                          // measureList.add(measure);
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          measure = value;
                          desiredHostel=value.toString();
                        });
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Contact Number',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                          BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.contains(RegExp(r'^[a-zA-Z\-]'))) {
                        return 'Use only numbers!';
                      }
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        contactNumber = value;
                        // bodyTempList.add(bodyTemp);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        contactNumber = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {


                        _submit();
                      }
                    },
                    child: const Text("Submit"),
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  Text(
                    '${"Made by Vaibhav Tiwari(102117089)"}',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            const Text("New data",
                style: TextStyle(
                  fontSize: 24,
                )),
            const Spacer(),
            ElevatedButton(
              child: const Text('New'),
              onPressed: () => Navigator.pop(context),
            )
          ]),
        ]),
      ),
    );
  }
}

extension StringExtension on String {
  // Method used for capitalizing the input from the form
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class MyResult extends StatefulWidget{
  const MyResult({Key? key}) : super(key: key);

  @override
  _MyResultState createState() => _MyResultState();
}

class _MyResultState extends State<MyResult>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results '),
      ),
        body: ListView.builder(
            itemCount: lstNamelength,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                margin: EdgeInsets.all(2),
                color: Colors.white,
                child: Center(
                    child: Text(
                      '${lstName[index]}     +91:${lstContact[index]}',
                      style: TextStyle(fontSize: 22, color: Colors.black),
                    )
                ),
              );
            })
       //Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(children: <Widget>[
      //     Row(children: <Widget>[
      //       const Text("",
      //           style: TextStyle(
      //             fontSize: 24,
      //           )),
      //       const Spacer(),
            // ElevatedButton(
            //   child: const Text('New'),
            //   onPressed: () async{
            //     Navigator.pop(context);
            //
            //   lstName.forEach((element) {if(element !="") print(element);});
            //   },
            // )
          //]),
        //]),
      //),
    );
  }
}



