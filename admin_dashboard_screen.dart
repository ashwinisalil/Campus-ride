import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/custom_button.dart';
import '../auth/role_selection_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _pushController = TextEditingController();

  final List<Map<String, String>> _studentsList = [
    {'name': 'Shravani', 'prn': 'PRN20248901', 'dept': 'Computer Engg', 'bus': 'Bus #04', 'status': 'Active'},
    {'name': 'Amit Kumar', 'prn': 'PRN20248902', 'dept': 'Information Tech', 'bus': 'Bus #02', 'status': 'Absent'},
    {'name': 'Priya Sharma', 'prn': 'PRN20248903', 'dept': 'Electronics', 'bus': 'Bus #01', 'status': 'Active'},
    {'name': 'Rohan Verma', 'prn': 'PRN20248904', 'dept': 'Mechanical', 'bus': 'Bus #04', 'status': 'Active'},
  ];

  final List<Map<String, String>> _driversList = [
    {'name': 'Rajesh Sharma', 'id': 'DRV-4091', 'bus': 'Bus #04', 'phone': '+91 98765 43211', 'license': 'MH12-2018-0091'},
    {'name': 'Suresh Patil', 'id': 'DRV-4092', 'bus': 'Bus #02', 'phone': '+91 98765 43222', 'license': 'MH12-2019-0092'},
    {'name': 'Mahesh Pawar', 'id': 'DRV-4093', 'bus': 'Bus #01', 'phone': '+91 98765 43233', 'license': 'MH12-2020-0093'},
  ];

  final List<Map<String, dynamic>> _busesFleet = [
    {'busNo': 'Bus #04', 'route': 'Route A', 'driver': 'Rajesh Sharma', 'speed': '42.0 km/h', 'fuel': '85%', 'status': 'Running'},
    {'busNo': 'Bus #02', 'route': 'Route B', 'driver': 'Suresh Patil', 'speed': '38.5 km/h', 'fuel': '62%', 'status': 'Running'},
    {'busNo': 'Bus #01', 'route': 'Route C', 'driver': 'Mahesh Pawar', 'speed': '0.0 km/h', 'fuel': '90%', 'status': 'Halted'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Command Center'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () {
              appState.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                (route) => false,
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard_rounded), text: 'Overview'),
            Tab(icon: Icon(Icons.school_rounded), text: 'Students'),
            Tab(icon: Icon(Icons.badge_rounded), text: 'Drivers'),
            Tab(icon: Icon(Icons.directions_bus_rounded), text: 'Bus Status'),
            Tab(icon: Icon(Icons.analytics_rounded), text: 'Weekly Reports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(appState),
          _buildStudentsTab(),
          _buildDriversTab(),
          _buildBusStatusTab(),
          _buildWeeklyReportsTab(),
        ],
      ),
    );
  }

  // 1. Overview Tab
  Widget _buildOverviewTab(AppState appState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassContainer(
            borderRadius: 22,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Fleet Monitoring Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('Active Fleet', '12 Buses', Colors.blue),
                    _buildStat('Drivers On Duty', '10 Drivers', Colors.green),
                    _buildStat('Total Students', '1,420 Enrolled', Colors.purple),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'MONITOR LIVE GPS MAP',
            icon: Icons.map_rounded,
            onPressed: () => appState.launchGoogleMapsForBus(),
          ),
          const SizedBox(height: 24),
          GlassContainer(
            borderRadius: 20,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Broadcast FCM Push Alert', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _pushController,
                  decoration: const InputDecoration(hintText: 'Enter alert message...', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_pushController.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Push Notification Broadcasted!'), backgroundColor: Colors.green),
                      );
                      _pushController.clear();
                    }
                  },
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                  label: const Text('SEND PUSH ALERT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, minimumSize: const Size(double.infinity, 46)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Student Management Tab
  Widget _buildStudentsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _studentsList.length,
      itemBuilder: (context, index) {
        final s = _studentsList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: GlassContainer(
            borderRadius: 18,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('${s['prn']} • ${s['dept']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('Assigned: ${s['bus']}', style: const TextStyle(fontSize: 12, color: Colors.blueAccent)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: s['status'] == 'Active' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    s['status']!,
                    style: TextStyle(color: s['status'] == 'Active' ? Colors.green : Colors.orange, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 3. Driver Management Tab
  Widget _buildDriversTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _driversList.length,
      itemBuilder: (context, index) {
        final d = _driversList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: GlassContainer(
            borderRadius: 18,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.2),
                  child: const Icon(Icons.person_rounded, color: Colors.green),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('License: ${d['license']} • ID: ${d['id']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      Text('Assigned Bus: ${d['bus']} • ${d['phone']}', style: const TextStyle(fontSize: 12, color: Colors.green)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 4. Bus Status Tab
  Widget _buildBusStatusTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _busesFleet.length,
      itemBuilder: (context, index) {
        final b = _busesFleet[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: GlassContainer(
            borderRadius: 18,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(b['busNo'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: b['status'] == 'Running' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        b['status'] as String,
                        style: TextStyle(color: b['status'] == 'Running' ? Colors.green : Colors.orange, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Route: ${b['route']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('Speed: ${b['speed']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('Fuel: ${b['fuel']}', style: const TextStyle(fontSize: 12, color: Colors.blueAccent)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 5. Weekly Reports Tab
  Widget _buildWeeklyReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassContainer(
            borderRadius: 22,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Weekly Fleet Performance & Ridership', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildReportMetric('Total Trips Completed', '168 Trips', Colors.blue),
                _buildReportMetric('Weekly Attendance Rate', '94.2%', Colors.green),
                _buildReportMetric('Average Bus Delay', '3.2 Mins', Colors.amber),
                _buildReportMetric('Total Onboard Students', '4,820 Student Rides', Colors.purple),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'DOWNLOAD WEEKLY REPORT (PDF)',
            icon: Icons.download_rounded,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading Weekly Campus Ridership PDF Report...'), backgroundColor: Colors.blue),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String title, String val, Color color) {
    return Column(
      children: [
        Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildReportMetric(String label, String val, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
