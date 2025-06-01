import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CameraPosition initialPosition = const CameraPosition(
    target: LatLng(37.5214, 126.9246),
    zoom: 15,
  );

  bool choolCheckDone = false;
  bool canChoolCheck = false;

  final double okDistance = 100;

  // final 제거
  late GoogleMapController controller;
  late Future<bool> _permissionGranted;

  @override
  void initState() {
    super.initState();

    _permissionGranted = checkPermission();

    Geolocator.getPositionStream().listen((event) {
      final start = LatLng(37.5214, 126.9246);
      final end = LatLng(event.latitude, event.longitude);
      final distance = Geolocator.distanceBetween(
        start.latitude,
        start.longitude,
        end.latitude,
        end.longitude,
      );

      final newCanChoolCheck = distance <= okDistance;
      if (newCanChoolCheck != canChoolCheck) {
        setState(() {
          canChoolCheck = newCanChoolCheck;
        });
      }
    });
  }

  Future<bool> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      debugPrint('위치 기능을 활성화 해주세요.');
      return false; // 예외 던지지 않고 false 반환
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      debugPrint('❗위치 권한이 거부 되었습니다.');
      return false; // 예외 던지지 않고 false 반환
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // 타이틀 가운데 정렬
        title: const Text(
          '오늘도 출근',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: myLocationPressed,
            icon: const Icon(Icons.my_location),
            color: Colors.blue,
          ),
        ],
      ),
      body: FutureBuilder(
        future: _permissionGranted,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          return Column(
            children: [
              Expanded(
                flex: 2,
                child: GoogleMap(
                  initialCameraPosition: initialPosition,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  // 변수 이름 변경
                  onMapCreated: (GoogleMapController mapController) {
                    controller = mapController;
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId('123'),
                      position: LatLng(37.5214, 126.9246),
                    ),
                  },
                  circles: {
                    Circle(
                      circleId: CircleId('inDistance'),
                      center: LatLng(37.5214, 126.9246),
                      radius: okDistance, // 반경은 미터 단위
                      fillColor: canChoolCheck
                          ? Colors.blue.withOpacity(0.3)
                          : Colors.red.withOpacity(0.3),
                      strokeColor: canChoolCheck ? Colors.blue : Colors.red,
                      strokeWidth: 1,
                    ),
                  },
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      choolCheckDone ? Icons.check : Icons.timelapse_outlined,
                      color: choolCheckDone ? Colors.green : Colors.blue,
                    ),
                    SizedBox(height: 16.0),
                    if (!choolCheckDone && canChoolCheck)
                      OutlinedButton(
                        onPressed: coolCheckPressed,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        child: Text('출근하기'),
                      )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  coolCheckPressed() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('출근하기'),
          content: Text('출근을 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: Text('출근하기'),
            ),
          ],
        );
      },
    );

    if (result) {
      setState(() {
        choolCheckDone = result;
      });
    }
  }

  myLocationPressed() async {
    final location = await Geolocator.getCurrentPosition();

    controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          location.latitude,
          location.longitude,
        ),
      ),
    );
  }
}
