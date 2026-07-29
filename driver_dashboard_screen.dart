import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/sos_dialog.dart';
import '../auth/role_selection_screen.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  bool _isTripActive = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final bus = appState.currentBus;
    final absentees = appState.driverAbsenteeList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Console Dashboard'),
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver Profile Header Card
            GlassContainer(
              borderRadius: 22,
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.emeraldGreen.withOpacity(0.2),
                    child: const Icon(Icons.person_rounded, size: 36, color: Colors.emeraldGreen),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rajesh Sharma',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Assigned: ${bus.busNumber} • Route A (City Central)',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Start / Stop Trip Control Card
            GlassContainer(
              borderRadius: 22,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Trip Status',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: _isTripActive,
                        activeColor: Colors.green,
                        onChanged: (val) {
                          setState(() => _isTripActive = val);
                          if (val && !appState.isDriverLive) {
                            appState.toggleDriverLiveStatus();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: _isTripActive ? 'STOP RIDE & END BROADCAST' : 'START RIDE & BROADCAST GPS',
                    icon: _isTripActive ? Icons.stop_circle_rounded : Icons.play_circle_fill_rounded,
                    gradient: _isTripActive
                        ? const LinearGradient(colors: [Colors.redAccent, Colors.deepOrange])
                        : const LinearGradient(colors: [Colors.green, Colors.teal]),
                    onPressed: () {
                      setState(() => _isTripActive = !_isTripActive);
                      appState.toggleDriverLiveStatus();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Students "Not Coming Today" Absentee Alert Console
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Students Absent Today',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.notifications_active_rounded, color: Colors.orangeAccent),
              ],
            ),
            const SizedBox(height: 10),
            GlassContainer(
              borderRadius: 20,
              padding: const EdgeInsets.all(16),
              child: absentees.isEmpty
                  ? const Text('No student absentees reported for today.', style: TextStyle(color: Colors.grey))
                  : Column(
                      children: absentees.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.person_off_rounded, color: Colors.orange, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item['studentName']} (Not Coming)',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Text(
                                      'Pickup Stop: ${item['pickupPoint']}',
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                item['time'] ?? 'Today',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 20),

            // Live Metrics Counter Grid
            Row(
              children: [
                Expanded(
                  child: GlassContainer(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        const Icon(Icons.people_rounded, color: Colors.blue, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          '${appState.todaysAttendanceCount}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Students Onboard',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: GlassContainer(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Icon(
                          Icons.radar_rounded,
                          color: appState.isDriverLive ? Colors.green : Colors.grey,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          appState.isDriverLive ? 'LIVE' : 'OFFLINE',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: appState.isDriverLive ? Colors.green : Colors.grey,
                          ),
                        ),
                        const Text(
                          'GPS Streaming',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Driver Actions
            ElevatedButton.icon(
              onPressed: () {
                appState.markQRAttendance();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Student attendance verified & logged into Firestore!')),
                );
              },
              icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
              label: const Text(
                'VERIFY STUDENT ATTENDANCE (SCAN QR)',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                showDialog(context: context, builder: (context) => const SOSDialog());
              },
              icon: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              label: const Text(
                'TRIGGER DRIVER EMERGENCY ALERT',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
