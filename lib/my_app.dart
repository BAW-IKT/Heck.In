import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const HedgeProfilerApp());

class HedgeProfilerApp extends StatelessWidget {
  const HedgeProfilerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedge Profiler',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const WebViewPage(),
    );
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  var loadingPercentage = 0;
  late final WebViewController _controller;
  bool _showNameForm = true;
  final NameForm _nameForm = const NameForm();
  String _currentUrlStem = '';

  @override
  void initState() {
    super.initState();

    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              loadingPercentage = 0;
            });
            debugPrint('Page started loading: $url');
          },
          onProgress: (int progress) {
            setState(() {
              loadingPercentage = progress;
            });
            debugPrint('WebView is loading (progress: $progress%)');
          },
          onPageFinished: (String url) {
            setState(() {
              loadingPercentage = 100;
            });
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              loadingPercentage = 0;
            });
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      );

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hedge Profiler'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigoAccent,
              ),
              child: Text('BAW Hedge Profiler\nMenu'),
            ),
            ListTile(
              leading: const Icon(Icons.eco_rounded, color: Colors.green),
              title: const Text('Rate Hedge'),
              onTap: () {
                setState(() {
                  _showNameForm = true;
                });
                Navigator.pop(context);
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (BuildContext context) => _form));
              },
            ),
            ListTile(
              leading: const Icon(Icons.map_outlined, color: Colors.red),
              title: const Text('Arcanum'),
              onTap: () {
                setState(() {
                  _showNameForm = false;
                });
                _loadPage(context,
                    'https://maps.arcanum.com/en/map/europe-19century-secondsurvey/?bbox=703865.3388931998%2C6876591.638315973%2C1744020.4197978782%2C7349889.717457783&map-list=1&layers=osm%2C158%2C164');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.map_outlined, color: Colors.blue),
              title: const Text('Bodenkarte'),
              onTap: () {
                setState(() {
                  _showNameForm = false;
                });
                _loadPage(context,
                    'https://bodenkarte.at/#/center/16.3191,48.1968/zoom/13');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
          if (_showNameForm)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: _nameForm,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _loadPage(BuildContext context, String url) async {
    String stem = RegExp("http.*(com|at)").firstMatch(url)?.group(0) ?? '';
    if (_currentUrlStem != stem && stem != '') {
      _currentUrlStem = stem;

      // load page via controller
      _controller.loadRequest(Uri.parse(url));
    }
  }
}

class NameForm extends StatefulWidget {
  const NameForm({Key? key}) : super(key: key);

  @override
  State<NameForm> createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _persistInputStorage();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _populateInputFields();
  }

  void _populateInputFields() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('name') ?? '';
    _numberController.text = prefs.getString('number') ?? '';
  }

  void _persistInputStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _nameController.text.trim());
    prefs.setString('number', _numberController.text.trim());
  }

  void _clearInputStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _populateInputFields();
  }

  void _saveFormData() {
    //TODO: implement writing to database
    final name = _nameController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Profile the Hedge!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Number',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _saveFormData();
                }
              },
              child: const Text('Submit'),
            ),
            ElevatedButton(
                onPressed: _clearInputStorage,
                child: const Text('Clear')
            )
          ],
        ),
      ),
    );
  }
}
