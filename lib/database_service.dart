import 'package:postgres/postgres.dart';

class DatabaseService {
  final String host;
  final int port;
  final String databaseName;
  final String username;
  final String password;

  DatabaseService({
    required this.host,
    required this.port,
    required this.databaseName,
    required this.username,
    required this.password,
  });

  Future<List<Map<String, dynamic>>> fetchScorpions() async {
    final PostgreSQLConnection connection = PostgreSQLConnection(
      host,
      port,
      databaseName,
      username: username,
      password: password,
    );

    await connection.open();

    final List<List<dynamic>> results = await connection.query('SELECT * FROM scorpions');

    await connection.close();

    // Convertir les résultats en liste de maps pour faciliter l'utilisation dans Flutter
    List<Map<String, dynamic>> scorpions = results.map((row) {
      return {
        'id': row[0],
        'name': row[1],
        'description': row[2],
        'imagePath': row[8], // Assurez-vous d'adapter cet index en fonction de votre structure de table
      };
    }).toList();

    return scorpions;
  }
}
