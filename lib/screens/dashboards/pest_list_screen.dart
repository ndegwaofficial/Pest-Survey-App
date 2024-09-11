import 'package:flutter/material.dart';
import 'package:pest_survey_app/screens/forms/survey_form.dart';
import 'package:postgres/postgres.dart';

class PestListScreen extends StatefulWidget {
  const PestListScreen({super.key});

  @override
  _PestListScreenState createState() => _PestListScreenState();
}

class _PestListScreenState extends State<PestListScreen> {
  List<Map<String, dynamic>> _countryPests = [];
  List<Map<String, dynamic>> _globalPests = [];

  @override
  void initState() {
    super.initState();
    _fetchPests();
  }

  Future<void> _fetchPests() async {
    final connection = PostgreSQLConnection(
      'localhost',
      5432,
      'pestsurveillance',
      username: 'postgres',
      password: '',
    );
    await connection.open();

    // Fetch Country Pest List
    List<List<dynamic>> countryResults = await connection.query('SELECT id, name, category FROM pests WHERE country = @country', substitutionValues: {
      'country': 'YourCountryName', // Replace with actual country filter
    });

    // Fetch Global Pest List
    List<List<dynamic>> globalResults = await connection.query('SELECT id, name, category FROM pests WHERE global = TRUE');

    setState(() {
      _countryPests = countryResults.map((row) {
        return {
          'id': row[0],
          'name': row[1],
          'category': row[2],
        };
      }).toList();

      _globalPests = globalResults.map((row) {
        return {
          'id': row[0],
          'name': row[1],
          'category': row[2],
        };
      }).toList();
    });

    await connection.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pest Lists'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Country Pest List'),
                Tab(text: 'Global Pest List'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPestListView(_countryPests),
                  _buildPestListView(_globalPests),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the pest list view with detection survey button
  Widget _buildPestListView(List<Map<String, dynamic>> pests) {
    return ListView.builder(
      itemCount: pests.length,
      itemBuilder: (context, index) {
        final pest = pests[index];
        return ListTile(
          title: Text(pest['name']),
          subtitle: Text('Category: ${pest['category']}'),
          trailing: ElevatedButton(
            onPressed: () {
              // Navigate to the detection survey form with the pest name pre-filled
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurveyForm(
                    'detection',
                    surveyType: 'detection',
                    initialPestName: pest['name'], // Pass pest name to the survey
                  ),
                ),
              );
            },
            child: const Text('Perform Detection Survey'),
          ),
        );
      },
    );
  }
}
