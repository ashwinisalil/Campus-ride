import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/bus_status_card.dart';
import '../../widgets/weather_card.dart';
import '../../widgets/quick_action_card.dart';
import '../../widgets/qr_attendance_modal.dart';
import '../../widgets/sos_dialog.dart';
import 'live_tracking_screen.dart';

class StudentHomeTab extends StatelessWidget {
  const StudentHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Greeting (GlucoLife Inspired)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                        child: Text(
                          user?.name.substring(0, 1).toUpperCase() ?? 'S',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Good Morning,',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          Text(
                            'Hello, ${user?.name ?? 'Shravani'}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${user?.department ?? 'Computer Engg'} • ${user?.year ?? '3rd Year'}',
                            style: const TextStyle(fontSize: 12, color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.sos_rounded, color: Colors.redAccent, size: 26),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const SOSDialog(),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Weather Status Card
              const WeatherCard(),
              const SizedBox(height: 18),

              // NOT COMING TODAY Button Card
              GlassContainer(
                borderRadius: 20,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                appState.isAbsentToday
                                    ? Icons.cancel_rounded
                                    : Icons.directions_bus_filled_rounded,
                                color: appState.isAbsentToday ? Colors.orangeAccent : Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                appState.isAbsentToday
                                    ? 'ABSENCE NOTIFIED TO DRIVER'
                                    : 'TODAY\'S BUS RIDE STATUS',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: appState.isAbsentToday ? Colors.orangeAccent : Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appState.isAbsentToday
                                ? 'Driver has been informed you won\'t be at pickup stop today.'
                                : 'Are you taking the bus today? Notify your driver if absent.',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: appState.isAbsentToday
                          ? null
                          : () {
                              appState.markNotComingToday();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Notified driver that you are NOT COMING TODAY!'),
                                  backgroundColor: Colors.orangeAccent,
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appState.isAbsentToday ? Colors.grey : Colors.orangeAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      child: Text(
                        appState.isAbsentToday ? 'NOTIFIED ✓' : 'NOT COMING TODAY',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Bus Status Card
              BusStatusCard(
                onLiveTrackPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LiveTrackingScreen()),
                  );
                },
              ),
              const SizedBox(height: 22),

              // Quick Actions Grid
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  QuickActionCard(
                    title: 'QR Pass',
                    icon: Icons.qr_code_scanner_rounded,
                    color: Colors.blue,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const QRAttendanceModal(),
                      );
                    },
                  ),
                  QuickActionCard(
                    title: 'Live Maps',
                    icon: Icons.map_rounded,
                    color: Colors.emeraldGreen,
                    onTap: () {
                      appState.launchGoogleMapsForBus();
                    },
                  ),
                  QuickActionCard(
                    title: 'SOS Alert',
                    icon: Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const SOSDialog(),
                      );
                    },
                  ),
                  QuickActionCard(
                    title: 'Schedule',
                    icon: Icons.calendar_today_rounded,
                    color: Colors.purpleAccent,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Today\'s Bus Schedule: Morning 08:00 AM | Evening 05:15 PM')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // College Announcements
              const Text(
                'Campus Announcements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GlassContainer(
                borderRadius: 18,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.campaign_rounded, color: Colors.orange),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transportation Notice',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Special evening shuttle bus arranged for library study hours until 08:30 PM.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
