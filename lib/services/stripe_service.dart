import 'package:dio/dio.dart';

class StripeService {
  static const String _baseUrl = 'https://smartosaresu.onrender.com/api';

  // Crear payment intent (cliente)
  static Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    required String customerId,
    String? description,
  }) async {
    try {
      final response = await Dio().post(
        '$_baseUrl/pagos/create-payment-intent/',
        data: {
          'amount': (amount * 100).toInt(), // Stripe usa centavos
          'currency': currency,
          'customer_id': customerId,
          'description': description,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al crear payment intent: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Procesar pago con tarjeta
  static Future<Map<String, dynamic>> processPayment({
    required String paymentIntentId,
    required String cardNumber,
    required String cardExpiry, // MM/YY
    required String cardCvc,
    required String cardHolderName,
  }) async {
    try {
      // Validar formato básico
      if (cardNumber.length < 13 || cardNumber.length > 19) {
        throw Exception('Número de tarjeta inválido');
      }
      if (cardCvc.length < 3 || cardCvc.length > 4) {
        throw Exception('CVC inválido');
      }

      final response = await Dio().post(
        '$_baseUrl/pagos/process-payment/',
        data: {
          'payment_intent_id': paymentIntentId,
          'card_number': cardNumber.replaceAll(' ', ''),
          'card_expiry': cardExpiry,
          'card_cvc': cardCvc,
          'cardholder_name': cardHolderName,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al procesar pago: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Guardar tarjeta de pago
  static Future<Map<String, dynamic>> savePaymentMethod({
    required String customerId,
    required String cardNumber,
    required String cardExpiry,
    required String cardCvc,
    required String cardHolderName,
    String? nickname,
  }) async {
    try {
      final response = await Dio().post(
        '$_baseUrl/pagos/save-payment-method/',
        data: {
          'customer_id': customerId,
          'card_number': cardNumber.replaceAll(' ', ''),
          'card_expiry': cardExpiry,
          'card_cvc': cardCvc,
          'cardholder_name': cardHolderName,
          'nickname': nickname,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Error al guardar tarjeta: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Obtener métodos de pago guardados
  static Future<List<Map<String, dynamic>>> getPaymentMethods(
      String customerId) async {
    try {
      final response = await Dio().get(
        '$_baseUrl/pagos/payment-methods/',
        queryParameters: {'customer_id': customerId},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final List data = response.data['payment_methods'] ?? [];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Error al obtener métodos: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Eliminar método de pago
  static Future<void> deletePaymentMethod({
    required String customerId,
    required String paymentMethodId,
  }) async {
    try {
      final response = await Dio().delete(
        '$_baseUrl/pagos/payment-methods/$paymentMethodId/',
        queryParameters: {'customer_id': customerId},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar método: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Obtener transacciones
  static Future<List<Map<String, dynamic>>> getTransactions(
      String customerId) async {
    try {
      final response = await Dio().get(
        '$_baseUrl/pagos/transactions/',
        queryParameters: {'customer_id': customerId},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final List data = response.data['transactions'] ?? [];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Error al obtener transacciones: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Reembolsar transacción
  static Future<Map<String, dynamic>> refundTransaction(
      String transactionId) async {
    try {
      final response = await Dio().post(
        '$_baseUrl/pagos/refund/',
        data: {'transaction_id': transactionId},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al reembolsar: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Validar tarjeta (Luhn algorithm)
  static bool validateCardNumber(String cardNumber) {
    final cleaned = cardNumber.replaceAll(' ', '');
    if (cleaned.isEmpty || cleaned.length < 13 || cleaned.length > 19) {
      return false;
    }

    int sum = 0;
    bool isEven = false;

    for (int i = cleaned.length - 1; i >= 0; i--) {
      int digit = int.parse(cleaned[i]);

      if (isEven) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      isEven = !isEven;
    }

    return sum % 10 == 0;
  }

  // Obtener tipo de tarjeta
  static String getCardType(String cardNumber) {
    final cleaned = cardNumber.replaceAll(' ', '');

    if (cleaned.startsWith('4')) {
      return 'Visa';
    } else if (cleaned.startsWith('5')) {
      return 'Mastercard';
    } else if (cleaned.startsWith('3')) {
      return 'American Express';
    } else if (cleaned.startsWith('6')) {
      return 'Discover';
    }

    return 'Desconocida';
  }
}
