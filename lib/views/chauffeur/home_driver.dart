import 'package:flutter/material.dart';




class HomeDriver extends StatefulWidget {
  @override
  _HomeDriverState createState() => _HomeDriverState();
}

class _HomeDriverState extends State<HomeDriver> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    OffersPage(),
    PlannedPage(),
    FinishedPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('BLACKLANE', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {
              // Action pour le bouton de profil
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Planned',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Finished',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hello, Kodjo Homawoo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Card(
            color: Colors.white,
            child: ListTile(
              title: Text('Today, 14:45'),
              subtitle: Text('Holcim Innovation Center, Rue du Montmurier 95, ...'),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
          SizedBox(height: 20),
          Card(
            color: Colors.white,
            child: ListTile(
              title: Row(
                children: [
                  Text('4.00', style: TextStyle(fontSize: 24)),
                  Icon(Icons.star, color: Colors.yellow),
                  Icon(Icons.star, color: Colors.yellow),
                  Icon(Icons.star, color: Colors.yellow),
                  Icon(Icons.star, color: Colors.yellow),
                  Icon(Icons.star_border),
                ],
              ),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
          SizedBox(height: 20),
          Card(
            color: Colors.white,
            child: ListTile(
              title: Text('News and updates'),
              subtitle: Text('have a new home'),
              trailing: Icon(Icons.arrow_forward, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}

class OffersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Offers Page'),
    );
  }
}

class PlannedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Planned Page'),
    );
  }
}

class FinishedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Finished Page'),
    );
  }
}
