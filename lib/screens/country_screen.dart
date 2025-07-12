import 'package:country_api/model/country.dart';
import 'package:country_api/screens/country_details.dart';
import 'package:country_api/screens/login_screen.dart';
import 'package:country_api/service/country_service.dart';
import 'package:country_api/service/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({Key? key, required String title}) : super(key: key);

  @override
  _CountriesScreenState createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final CountryService _countryService = CountryService();
  TextEditingController textEditingController = TextEditingController();

  //future
  late Future<List<Country>> _countriesFuture;

  late List<Country> _countries;

  late List<Country> _paisesFiltrados;

  @override
  void initState() {
    super.initState();
    _countriesFuture = getCountries();
  }

  Future<List<Country>> getCountries() async {
    _countries = await _countryService.getCountries();
    _paisesFiltrados = _countries;
    return _countries;
  }

  void _filtroPaises(String filtro) {
    final termo = filtro.toLowerCase().trim();

    setState(() {
      _paisesFiltrados =
          filtro.isEmpty
              ? List.from(_countries)
              : _countries
                  .where(
                    (p) =>
                        p.name.common.toLowerCase().contains(termo) ||
                        p.name.official.toLowerCase().contains(termo),
                  )
                  .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Países do Mundo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
             _auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginPage();
                  },
                ),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 245, 74, 22),
        centerTitle: true,
      ),

      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 74, 22),
              ),
              child: Text(
                'Países',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: const Text("Detalhes"),
              leading: Icon(Icons.map),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Item 2'),
              leading: Icon(Icons.maps_home_work),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 50 / 100,
            child: FutureBuilder<List<Country>>(
              future: _countriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum país encontrado'));
                }
                return ListView.builder(
                  itemCount: _paisesFiltrados.length,
                  itemBuilder: (context, index) {
                    final country = _paisesFiltrados[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading:
                            country.flagUrl.isNotEmpty
                                ? Image.network(
                                  country.flagUrl,
                                  width: 50,
                                  height: 30,
                                  fit: BoxFit.cover,
                                )
                                : const Icon(Icons.flag),
                        title: Text(
                          country.name.common,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          country.name.official,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => CountryDetails(country: country),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 150,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Buscar país"),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _filtroPaises(value);
              },
            ),
          ),
        ),
      ),
    );
  }
}
