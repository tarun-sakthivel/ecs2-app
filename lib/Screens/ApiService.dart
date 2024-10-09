import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // Method to retrain the model
  Future<String> retrainModel(List<Map<String, dynamic>> feedbackData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/retrainmodel'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'feedbacks': feedbackData}),
    );

    if (response.statusCode == 201) {
      return 'Model retrained successfully';
    } else {
      throw Exception('Failed to retrain model: ${response.body}');
    }
  }

  Future<String> getPrediction(List<int> inputData) async {
    try {
      // Convert the list of integers to JSON format
      String jsonData = jsonEncode({'data': inputData});

      // Construct the full URL for the POST request
      String url = '$baseUrl/predict';

      // Log the request being sent
      print('Sending POST request to: $url with data: $jsonData');

      // Send the POST request to the FastAPI endpoint
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // Ensures correct content type
          'Accept': 'application/json',
        },
        body: jsonData, // Send the input data as JSON in the body
      );

      // If the response is successful (status code 201)
      if (response.statusCode == 201) {
        // Decode the JSON response and extract the prediction
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if 'prediction' exists in the response
        if (responseData.containsKey('prediction')) {
          final prediction = responseData['prediction'];

          // Log the actual prediction value for debugging
          print('Received prediction: $prediction');

          // Ensure that 'prediction' is a valid number (double or int)
          return prediction;
        } else {
          throw Exception('Prediction key is missing in the response');
        }
      } else {
        // If the server responds with an error (e.g., 422)
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get prediction: ${response.body}');
      }
    } catch (e) {
      // Log and rethrow any exceptions
      print('Exception occurred: $e');
      throw Exception('Failed to get prediction: $e');
    }
  }
// Future<double> getPrediction(List<int> inputData) async {
//   try {
//     // Convert the list of integers to JSON format
//     String jsonData = jsonEncode({'data': inputData});

//     // Construct the full URL for the POST request
//     String url = '$baseUrl/predict';

//     // Log the request being sent
//     print('Sending POST request to: $url with data: $jsonData');

//     // Send the POST request to the FastAPI endpoint
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json', // Ensures correct content type
//         'Accept': 'application/json',
//       },
//       body: jsonData, // Send the input data as JSON in the body
//     );

//     // If the response is successful (status code 201)
//     if (response.statusCode == 201) {
//       // Decode the JSON response and extract the prediction
//       final responseData = jsonDecode(response.body);

//       // Check if 'prediction' exists in the response
//       if (responseData.containsKey('prediction')) {
//         // Extract the prediction value
//         final prediction = responseData['prediction'];

//         // Ensure that 'prediction' is either a double or int
//         if (prediction is double) {
//           return prediction;
//         } else if (prediction is int) {
//           return prediction.toDouble(); // Convert int to double if necessary
//         } else {
//           throw Exception('Prediction value is not a valid number');
//         }
//       } else {
//         throw Exception('Prediction key missing in response');
//       }
//     } else {
//       // If the server responds but with an error (like 422)
//       print('Error: ${response.statusCode} - ${response.body}');
//       throw Exception('Failed to get prediction: ${response.body}');
//     }
//   } catch (e) {
//     // If any exception occurs, log it and rethrow the error
//     print('Exception occurred: $e');
//     throw Exception('Failed to get prediction: $e');
//   }
// }
  // Future<double> getPrediction(List<int> inputData) async {
  //   try {
  //     // Convert the list of integers to JSON format
  //     String jsonData = jsonEncode({'data': inputData});

  //     // Construct the full URL for the POST request
  //     String url = '$baseUrl/predict';

  //     // Log the request being sent
  //     print('Sending POST request to: $url with data: $jsonData');

  //     // Send the POST request to the FastAPI endpoint
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json', // Ensures correct content type
  //         'Accept': 'application/json',
  //       },
  //       body: jsonData, // Send the input data as JSON in the body
  //     );

  //     // If the response is successful (status code 201)
  //     if (response.statusCode == 201) {
  //       // Decode the JSON response and extract the prediction
  //       final responseData = jsonDecode(response.body);

  //       // Ensure the response has the expected structure
  //       if (responseData.containsKey('prediction')) {
  //         return responseData['prediction'];
  //       } else {
  //         throw Exception('Prediction key missing in response');
  //       }
  //     } else {
  //       // If the server responds but with an error (like 422)
  //       print('Error: ${response.statusCode} - ${response.body}');
  //       throw Exception('Failed to get prediction: ${response.body}');
  //     }
  //   } catch (e) {
  //     // If any exception occurs, log it and rethrow the error
  //     print('Exception occurred: $e');
  //     throw Exception('Failed to get prediction: $e');
  //   }
  // }
  // Future<double> getPrediction(List<double> inputData) async {
  //   // Join the input data into a comma-separated string
  //   final String queryString = inputData.join(',');
  //   print(queryString);
  //   final response = await http.get(
  //     Uri.parse(
  //         '$baseUrl/predict?input=$queryString'), // Send data as query parameters
  //   );

  //   if (response.statusCode == 200) {
  //     final responseData = jsonDecode(response.body);
  //     return responseData['prediction'];
  //   } else {
  //     throw Exception('Failed to get prediction: ${response.body}');
  //   }
  // }
}
