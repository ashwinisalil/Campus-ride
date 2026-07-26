import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/custom_button.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  bool _trafficLayerEnabled = true;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final bus = appState.currentBus;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live GPS Tracking'),
        actions: [
          IconButton(
            icon: Icon(
              _trafficLayerEnabled ? Icons.traffic_rounded : Icons.traffic_outlined,
              color: _trafficLayerEnabled ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              setState(() => _trafficLayerEnabled = !_trafficLayerEnabled);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Live Visual Map Display Area
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF1E293B),
            child: Stack(
              children: [
                // Simulated Map Polyline & Grid Background
                CustomPaint(
                  size: Size.infinite,
                  painter: MapGridPainter(trafficEnabled: _trafficLayerEnabled),
                ),
                // Moving Bus Marker Indicator
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.35,
                  left: MediaQuery.of(context).size.width * 0.45,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                              blurRadius: 18,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.directions_bus_filled_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${bus.busNumber} • ${bus.currentSpeed.toStringAsFixed(1)} km/h',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Glass Card overlay with metrics and Google Maps trigger
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: GlassContainer(
              borderRadius: 24,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bus.busNumber,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Driver: ${bus.driverName} • ${bus.driverPhone}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'ETA: ${bus.estimatedArrival}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetric('Distance', '3.4 km'),
                      _buildMetric('Next Stop', bus.nextStop),
                      _buildMetric('Occupancy', '${bus.currentOccupancy}/${bus.capacity}'),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Open Google Maps Application Button
                  CustomButton(
                    text: 'OPEN IN GOOGLE MAPS APP',
                    icon: Icons.open_in_new_rounded,
                    onPressed: () {
                      appState.launchGoogleMapsForBus();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String title, String val) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          val,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class MapGridPainter extends CustomPainter {
  final bool trafficEnabled;
  MapGridPainter({required this.trafficEnabled});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      color = Colors.white.withOpacity(0.05)
      strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Simulated Route Polyline
    final polylinePaint = Paint()
      color = trafficEnabled ? Colors.greenAccent : Colors.blueAccent
      strokeWidth = 6.0
      style = PaintingStyle.stroke;

    final path = Path()
      moveTo(size.width * 0.1, size.height * 0.1)
      lineTo(size.width * 0.45, size.height * 0.35)
      lineTo(size.width * 0.8, size.height * 0.6)
      lineTo(size.width * 0.9, size.height * 0.85);

    canvas.drawPath(path, polylinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
