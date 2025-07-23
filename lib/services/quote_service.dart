import 'dart:convert';
import 'package:http/http.dart' as http;

// This service fetches a daily motivational quote from the ZenQuotes API
class QuoteService {
  // Static method to fetch today's quote
  static Future<String> fetchDailyQuote() async {
    final url = Uri.parse('https://zenquotes.io/api/today'); // API endpoint

    try {
      // Send a GET request to the API
      final response = await http.get(url);

      // If the request is successful (HTTP 200 OK)
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Decode the JSON response
        // Return the quote text with the author's name
        return '${data[0]["q"]} — ${data[0]["a"]}';
      } else {
        // Handle unexpected status codes
        return 'Unable to fetch quote.';
      }
    } catch (e) {
      // Handle network errors or parsing issues
      return 'Error fetching quote.';
    }
  }
}
