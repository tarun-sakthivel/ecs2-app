import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// Function to listen for changes in the Firestore document
Stream<DocumentSnapshot> listenToSensorData(String documentId) {
  // Replace 'sensors' with your collection name
  return FirebaseFirestore.instance
      .collection('sensor_data')   // Firestore collection name
      .doc('device_1')          // Document ID you are tracking
      .snapshots();             // Listen for real-time updates
}

// Example usage in a Flutter Widget
class SensorDataScreen extends StatelessWidget {
  final String documentId;  // Pass the document ID to the widget

  SensorDataScreen({required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sensor Data')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: listenToSensorData(documentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No Data Available'));
          }

          // Extracting the data
          var data = snapshot.data!.data() as Map<String, dynamic>;
          var temperature = data['temperature'] ?? 'N/A';
          var humidity = data['humidity'] ?? 'N/A';
          var moisture = data['soil_moisture'] ?? 'N/A';

          // Display the data
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Temperature: $temperature'),
                Text('Humidity: $humidity'),
                Text('Moisture: $moisture'),
              ],
            ),
          );
        },
      ),
    );
  }
}