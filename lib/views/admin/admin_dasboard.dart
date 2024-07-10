import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/views/login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  Future<void> _logout() async {
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2), // Space for the overlaid container
          _buildSalesAnalytics(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatisticCard(
                  'Total Revenue',
                  '\$12,743',
                  '-4.20% (-1.80)',
                  Colors.red,
                  true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatisticCard(
                  'Total Orders',
                  '473,680',
                  '+3.45% (+0.00%)',
                  Colors.blue,
                  true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatisticCard(
                  'Total Customers',
                  '71,470',
                  '',
                  Colors.grey,
                  false,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatisticCard(
                  'Total Amount',
                  '\$73,840',
                  '',
                  Colors.grey,
                  false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalesAnalytics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sales Analytics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your annual statistics',
                style: TextStyle(color: Colors.grey),
              ),
              DropdownButton<String>(
                value: 'Yearly',
                items: <String>['Yearly', 'Monthly', 'Weekly']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(
                      toY: 15,
                      color: Colors.blue,
                      width: 12,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 20,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(
                      toY: 12,
                      color: Colors.blue,
                      width: 12,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 20,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(
                      toY: 18,
                      color: Colors.blue,
                      width: 12,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 20,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ]),
                  BarChartGroupData(x: 3, barRods: [
                    BarChartRodData(
                      toY: 20,
                      color: Colors.blue,
                      width: 12,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 20,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ]),
                  BarChartGroupData(x: 4, barRods: [
                    BarChartRodData(
                      toY: 16,
                      color: Colors.blue,
                      width: 12,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 20,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ]),
                  BarChartGroupData(x: 5, barRods: [
                    BarChartRodData(
                      toY: 13,
                      color: Colors.blue,
                      width: 12,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 20,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ]),
                ],
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(color: Colors.black, fontSize: 10);
                        Widget text;
                        switch (value.toInt()) {
                          case 10:
                            text = const Text('10k', style: style);
                            break;
                          case 15:
                            text = const Text('15k', style: style);
                            break;
                          case 20:
                            text = const Text('20k', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 4.0,
                          child: text,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(color: Colors.black, fontSize: 10);
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('Jan', style: style);
                            break;
                          case 1:
                            text = const Text('Feb', style: style);
                            break;
                          case 2:
                            text = const Text('Mar', style: style);
                            break;
                          case 3:
                            text = const Text('Apr', style: style);
                            break;
                          case 4:
                            text = const Text('May', style: style);
                            break;
                          case 5:
                            text = const Text('Jun', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 4.0,
                          child: text,
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(color: Colors.black, fontSize: 10);
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('0', style: style);
                            break;
                          case 5:
                            text = const Text('5', style: style);
                            break;
                          case 10:
                            text = const Text('10', style: style);
                            break;
                          case 15:
                            text = const Text('15', style: style);
                            break;
                          case 20:
                            text = const Text('20', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 4.0,
                          child: text,
                        );
                      },
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticCard(String title, String value, String change, Color color, bool isGraph) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey),
              ),
              if (isGraph)
                const Spacer(),
              if (isGraph)
                const Icon(Icons.insert_chart, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          if (change.isNotEmpty)
            Text(
              change,
              style: TextStyle(color: color),
            ),
          if (isGraph)
            const SizedBox(height: 8),
          if (isGraph)
            SizedBox(
              height: 50,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: color,
                      barWidth: 2,
                      spots: const [
                        FlSpot(0, 1),
                        FlSpot(1, 2),
                        FlSpot(2, 1.5),
                        FlSpot(3, 1.7),
                        FlSpot(4, 1.4),
                        FlSpot(5, 2),
                      ],
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  titlesData: const FlTitlesData(show: false),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: AppBar(
          backgroundColor: ColorsApp.primaryColor,
          flexibleSpace: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: ColorsApp.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Good morning',
                      style: TextStyle(fontSize: 18, color: Color.fromARGB(86, 255, 255, 255)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Didier Drogba',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_fire_department, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Your sales are down, let’s increase it again.',
                              style: TextStyle(color: ColorsApp.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // handle search action
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                // handle notifications action
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: _logout,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _buildBody(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Finance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Delivery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ColorsApp.primaryColor,
        unselectedItemColor: ColorsApp.greyColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
