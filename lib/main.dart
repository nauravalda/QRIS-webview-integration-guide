import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebViewPage(),
    );
  }
}

class WebViewPage extends StatefulWidget {
  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool isLoading = true;
  late InAppWebViewController webViewController;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    // Request permissions for camera and microphone
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Back",
            style: TextStyle(
                fontSize: 12, color: Color.fromARGB(255, 133, 114, 114))),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, // or any other icon you want
            size: 16,
            color: Color.fromARGB(255, 152, 140,
                140), // Change this value to set the size of the icon
          ),
          onPressed: () {
            // Define the action on button press (optional)
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest:
                  URLRequest(url: WebUri("https://wallet-stg.harsya.com/whitelabel/qris-payment?token=xxx")),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              initialSettings: InAppWebViewSettings(
                // Use initialSettings instead of settings
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
              ),
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                // Automatically grant permissions for camera/microphone
                return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT,
                );
              },
              onLoadStart: (controller, url) {
                setState(() {
                  isLoading = true;
                });
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  isLoading = false;
                });

                if (url != null && url.path.contains('/result')) {
                   // Inject JS to stop all camera streams
                  await controller.evaluateJavascript(source: """
                    if (window.streams) {
                      window.streams.forEach(s => s.getTracks().forEach(t => t.stop()));
                    }
                    if (window.localStream) {
                      window.localStream.getTracks().forEach(t => t.stop());
                    }
                    // Try to stop all media streams from all video elements
                    document.querySelectorAll('video').forEach(video => {
                      if (video.srcObject) {
                        video.srcObject.getTracks().forEach(track => track.stop());
                      }
                    });
                  """);
                }

          },

            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}



