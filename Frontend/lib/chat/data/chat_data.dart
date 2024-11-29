import 'dart:math';

class ChatData {
  static const predefinedResponses = {
    "What is the check-in time?": "Check-in starts at 2 PM.",
    "What is the check-out time?": "Check-out is at 12 PM.",
    "Do you allow pets?": "Yes, pets are allowed at an additional charge.",
    "Do you provide airport pickup?": "Yes, airport pickup is available upon request.",
    "What amenities are included?": "We offer free Wi-Fi, breakfast, a swimming pool, and gym access.",
    "Can I cancel my booking?": "Yes, cancellations are allowed up to 24 hours before check-in.",
    "Are there any nearby attractions?": "We are close to the City Museum, Central Park, and the Waterfront Mall.",
    "Do you have family rooms?": "Yes, family rooms are available for booking.",
    "Is breakfast complimentary?": "Yes, breakfast is included with your stay.",
    "Can I request an extra bed?": "Yes, extra beds are available upon request at an additional cost.",
    "Do you offer room service?": "Yes, room service is available 24/7.",
    "Is there a laundry service?": "Yes, we offer laundry services for a nominal fee.",
    "What time does the swimming pool close?": "The swimming pool is open until 10 PM.",
    "Do you have a fitness center?": "Yes, our hotel has a fully-equipped fitness center, open 24 hours.",
    "Is there free Wi-Fi?": "Yes, we provide free Wi-Fi throughout the hotel.",
    "Do you have a business center?": "Yes, we have a business center with computers and printers.",
    "Can I request a wake-up call?": "Yes, wake-up calls can be requested at the front desk.",
    "Is there parking available?": "Yes, we have a parking lot with spaces available for guests.",
    "What payment methods do you accept?": "We accept credit/debit cards, cash, and mobile payments.",
    "Do you have an ATM on-site?": "Yes, there is an ATM located in the lobby for your convenience.",
    "Do you offer guided tours?": "Yes, we offer guided tours of local attractions.",
    "Is smoking allowed in the hotel?": "Smoking is not allowed inside the hotel. There are designated smoking areas.",
    "What is the cancellation policy?": "Cancellations must be made at least 24 hours before check-in to avoid a fee.",
    "Can I book a room for someone else?": "Yes, you can book a room for someone else with the necessary identification details.",
    "What is your pet policy?": "Pets are allowed in specific rooms for an additional cleaning fee.",
    "Do you provide baby cribs?": "Yes, baby cribs are available upon request.",
    "Are there any discounts for extended stays?": "Yes, we offer discounts for stays longer than a week.",
    "Can I pay with points or rewards?": "Yes, if you're part of our loyalty program, you can use points to pay for your stay.",
    "Do you have meeting rooms?": "Yes, we have meeting rooms available for business events and conferences.",
    "Can I upgrade my room?": "Room upgrades are subject to availability at an additional cost.",
    "Do you have a spa?": "Yes, we have a spa that offers massages and beauty treatments.",
    "Is there a minibar in the room?": "Yes, each room is equipped with a minibar, stocked with drinks and snacks.",
    "What is your smoking policy?": "Smoking is prohibited inside the rooms, but we have designated smoking areas outside.",
    "Can I make special requests for my room?": "Yes, special requests like extra pillows or specific bed arrangements can be made at the time of booking.",
    "Do you have a loyalty program?": "Yes, we offer a loyalty program that provides discounts, exclusive offers, and more.",
    "Can I change my reservation?": "Yes, you can modify your reservation, subject to availability and policies.",
    "Do you offer shuttle service to the airport?": "Yes, we provide shuttle service to and from the airport upon request.",
    "Are there any nearby restaurants?": "Yes, there are several restaurants within walking distance from the hotel.",
    "Do you offer all-inclusive packages?": "Yes, we offer all-inclusive packages that include meals, drinks, and activities.",
    "Is there a concierge service?": "Yes, our concierge service can assist with bookings, local recommendations, and special requests.",
    "What is your check-in policy?": "You can check in from 2 PM onwards. Early check-ins are subject to availability.",
    "Do you allow early check-ins?": "Early check-ins are available based on room availability and a surcharge may apply.",
    "Can I use my own credit card for booking?": "Yes, you can use your own credit card for booking. Please ensure it is valid.",
    "What is the pet fee?": "There is an additional cleaning fee for pets, which varies depending on the room type.",
    "Are the rooms soundproof?": "Our rooms are designed to minimize noise, but they are not completely soundproof.",
    "Is there a restaurant on-site?": "Yes, we have a restaurant serving local and international cuisine.",
    "Can I book excursions through the hotel?": "Yes, we can arrange excursions and day trips at the reception.",
    "What is your policy on minors staying in rooms?": "Minors must be accompanied by an adult. Some rooms may have age restrictions.",
    "Can I bring my own food and drinks?": "Outside food and drinks are not allowed in the hotel, but we offer room service and restaurant options.",
    "Is there a medical facility nearby?": "Yes, there is a medical clinic within walking distance, and we also have an emergency medical kit on-site.",
    "Can I get a refund if I don't stay?": "Refunds depend on the cancellation policy, and cancellations made after the allowed window may incur a fee."
  };

  static String getResponse(String userQuery) {
    // Check for exact match
    if (predefinedResponses.containsKey(userQuery)) {
      return predefinedResponses[userQuery]!;
    }
    
    // Fuzzy matching for similar questions
    var bestMatch = getBestMatch(userQuery);
    return bestMatch != null ? predefinedResponses[bestMatch]! : "I'm sorry, I don't have an answer to that.";
  }

  // Simple method to calculate Levenshtein distance (edit distance) for string similarity
  static int _levenshteinDistance(String a, String b) {
    List<List<int>> dp = List.generate(a.length + 1, (i) => List.filled(b.length + 1, 0));

    for (int i = 0; i <= a.length; i++) dp[i][0] = i;
    for (int j = 0; j <= b.length; j++) dp[0][j] = j;

    for (int i = 1; i <= a.length; i++) {
      for (int j = 1; j <= b.length; j++) {
        int cost = a[i - 1] == b[j - 1] ? 0 : 1;
        dp[i][j] = min(
          min(dp[i - 1][j] + 1, dp[i][j - 1] + 1),
          dp[i - 1][j - 1] + cost,
        );
      }
    }

    return dp[a.length][b.length];
  }

  static String? getBestMatch(String userQuery) {
    String? bestMatch;
    int smallestDistance = 1000;

    predefinedResponses.keys.forEach((question) {
      int distance = _levenshteinDistance(userQuery.toLowerCase(), question.toLowerCase());
      if (distance < smallestDistance) {
        smallestDistance = distance;
        bestMatch = question;
      }
    });

    // Return the best match if the distance is small enough
    return bestMatch != null && smallestDistance <= 5 ? bestMatch : null;
  }
}
