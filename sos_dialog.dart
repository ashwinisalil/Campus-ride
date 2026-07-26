import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../config/constants.dart';
import 'glass_container.dart';

class SOSDialog extends StatelessWidget {
  const SOSDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassContainer(
        borderRadius: 28,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0x30EF4444),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'EMERGENCY SOS ALERT',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Do you want to broadcast your live GPS location and alert Campus Security?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                final Uri callUri = Uri.parse('tel:${AppConstants.campusSecurityPhone}');
                if (await canLaunchUrl(callUri)) {
                  await launchUrl(callUri);
                }
              },
              icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white),
              label: const Text(
                'CALL CAMPUS SECURITY',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                final Uri callUri = Uri.parse('tel:${AppConstants.driverEmergencyPhone}');
                if (await canLaunchUrl(callUri)) {
                  await launchUrl(callUri);
                }
              },
              icon: const Icon(Icons.directions_bus_rounded),
              label: const Text('CALL DRIVER DIRECTLY'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                appState.launchGoogleMapsForBus();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Live location broadcasted to emergency contacts!'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
              child: const Text('SHARE LIVE LOCATION NOW'),
            ),
          ],
        ),
      ),
    );
  }
}
