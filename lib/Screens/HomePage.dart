import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecs_app/Screens/ApiService.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DateTime time = DateTime.now();
  // Use the appropriate base URL based on your setup
  ApiService apiService = ApiService('http://10.0.2.2:8001'); // For emulator
  //ApiService apiService = ApiService('http://192.168.243.52:8001');
// For physical device
  String prediction = '';
  List nodes = [1, 2, 3];
  void retrainModel(
    String action,
    String moisture,
    String temperature,
    String humidity,
  ) async {
    try {
      print("Entering the retrainModel");
      List<Map<String, dynamic>> feedbackData = [
        {
          'moisture': '$moisture',
          'temperature': '$temperature',
          'humidity': '$humidity',
          'action': '$action'
        },

        // Add more feedbacks as needed
      ];

      final message = await apiService.retrainModel(feedbackData);
      print(message);

      showDialog(
        context: context,
        barrierDismissible: true, // Allows dismissal by tapping outside
        builder: (BuildContext context) {
          // Return a dialog widget
          return AlertDialog(
            content: SizedBox(
              height: 80,
              width: 300, // Adjust width as needed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Note:",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 22),
                      ),
                      Icon(
                        Icons.done,
                        color: Colors.green,
                      )
                    ],
                  ),
                  Text(message,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                ],
              ),
            ),
          );
        },
      );

      // Automatically dismiss the dialog after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Close the dialog
      });
      print('Success prediction');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      print(e);
    }
  }

  void predict(
    int moisture,
    int temperature,
    int humidity,
  ) async {
    try {
      List<int> inputData = [
        moisture,
        temperature,
        humidity
      ]; // Replace with actual input data
      print("Entering the predict method");

      // Call the prediction API
      prediction = await apiService.getPrediction(inputData);
      setState(() {
        prediction = prediction;
      });
      showDialog(
        context: context,
        barrierDismissible: true, // Allows dismissal by tapping outside
        builder: (BuildContext context) {
          // Return a dialog widget
          return AlertDialog(
            content: SizedBox(
              height: 80,
              width: 300, // Adjust width as needed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Note:",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 22),
                      ),
                      Icon(
                        Icons.done,
                        color: Colors.green,
                      )
                    ],
                  ),
                  Text("$prediction water for plants",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                ],
              ),
            ),
          );
        },
      );

      // Automatically dismiss the dialog after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Close the dialog
      });
      // Log the result
      print("Prediction: $prediction");

      // Optionally show the result in the UI
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(
      //     'Prediction: $prediction',
      //     style: TextStyle(fontSize: 16),
      //   ),
      // ));
    } catch (e) {
      // Handle errors
      print("Error occurred while getting the predicted value.");
      print(e);

      // Optionally show the error message in the UI
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  Stream<DocumentSnapshot> listenToSensorData() {
    // Replace 'sensors' with your collection name
    return FirebaseFirestore.instance
        .collection('sensor_data') // Firestore collection name
        .doc('device_1') // Document ID you are tracking
        .snapshots(); // Listen for real-time updates
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // predict();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: listenToSensorData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No Data Available'));
        }

        // Extracting the data
        var data = snapshot.data!.data() as Map<String, dynamic>;
        var temperature = data['temperature'] ?? 'N/A';
        var humidity = data['humidity'] ?? 'N/A';
        var moisture = data['soil_moisture'] ?? 'N/A';
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'HOME',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 150,
                    width: 380,
                    decoration: BoxDecoration(
                        color: const Color(0xfff67c0e8),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: Text(
                                      "${time.hour} :" "${time.minute}",
                                      style: const TextStyle(
                                          fontSize: 26, color: Colors.black),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: Text(
                                      "${time.day}.${time.month}.${time.year}",
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset("assets/images/Sun.png")
                            ],
                          ),
                          Text("Moisture level:$moisture"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Temperatue: $temperature C"),
                              Text("Humidity: $humidity"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    "Water the plant?",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: nodes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            height: 160,
                            width: 400,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 104, 245, 109),
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Unit \n ${index + 1}",
                                    style: TextStyle(fontSize: 26),
                                  ),
                                  const SizedBox(
                                    width: 60,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Prediction: $prediction Water",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              retrainModel("ON", moisture,
                                                  temperature, humidity);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: const Color.fromARGB(
                                                      255, 67, 67, 67)),
                                              child: const Center(
                                                child: Text(
                                                  'Water',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              retrainModel("OFF", moisture,
                                                  temperature, humidity);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: const Color.fromARGB(
                                                      255, 67, 67, 67)),
                                              child: const Center(
                                                child: Text(
                                                  'Don\'t water',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          predict(
                                              int.parse(moisture),
                                              int.parse(temperature),
                                              int.parse(humidity));
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color.fromARGB(
                                                  255, 67, 67, 67)),
                                          child: const Center(
                                            child: Text(
                                              'Predict',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
