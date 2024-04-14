import 'package:flutter/material.dart';
import 'package:scorpionsapp/database_service.dart'; // Importez votre service de base de données

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PostgreSQL Demo',
      home: ScorpionsListScreen(), // Utilisez votre écran de liste de scorpions comme page d'accueil
    );
  }
}

class ScorpionsListScreen extends StatelessWidget {
  final DatabaseService databaseService = DatabaseService(
    host: "172.17.0.3",
    port: 5432,
    databaseName: "mon-postgres",
    username: "Nadiabn",
    password: "nadiabnlajo8",
  );

  ScorpionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scorpions List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: databaseService.fetchScorpions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>>? scorpions = snapshot.data;
            if (scorpions == null || scorpions.isEmpty) {
              return const Center(child: Text('Aucun scorpion trouvé'));
            } else {
              return ListView.builder(
                itemCount: scorpions.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> scorpion = scorpions[index];
                  return ListTile(
                    title: Text(scorpion['name'] ?? ''),
                    subtitle: Text(scorpion['description'] ?? ''),
                    leading: scorpion['imagePath'] != null ? Image.network(scorpion['imagePath']) : Container(),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
