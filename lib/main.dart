import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF5B5BEA),
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared colors
// ---------------------------------------------------------------------------
const Color kBlue = Color(0xFF1E88E5);
const Color kPurple = Color(0xFF7C4DFF);
const Color kOrange = Color(0xFFFF7043);

const LinearGradient kMainGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kBlue, kPurple],
);

// ---------------------------------------------------------------------------
// Shell with bottom navigation (Home / About)
// ---------------------------------------------------------------------------
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          ConverterPage(),
          AboutPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.thermostat_outlined),
            selectedIcon: Icon(Icons.thermostat),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// App logo widget (uses the same image as the launcher icon)
// ---------------------------------------------------------------------------
class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.25),
        child: Image.asset(
          'assets/icon/app_icon.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => Container(
            decoration: const BoxDecoration(gradient: kMainGradient),
            child: const Icon(Icons.thermostat, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Home page: Temperature Converter
// ---------------------------------------------------------------------------
class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  static const String cToF = 'Celsius to Fahrenheit (°C → °F)';
  static const String fToC = 'Fahrenheit to Celsius (°F → °C)';

  final TextEditingController _controller = TextEditingController();
  String _selected = cToF;
  String? _errorText;
  String _result = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _calculate() {
    FocusScope.of(context).unfocus();
    final String input = _controller.text.trim();

    // Validation: empty
    if (input.isEmpty) {
      setState(() {
        _errorText = 'Please enter a temperature value';
        _result = '';
      });
      return;
    }

    // Validation: not a valid number
    final double? value = double.tryParse(input);
    if (value == null) {
      setState(() {
        _errorText = 'Please enter a valid number';
        _result = '';
      });
      return;
    }

    double converted;
    String unit;
    if (_selected == cToF) {
      converted = (value * 9 / 5) + 32; // F = (C × 9/5) + 32
      unit = '°F';
    } else {
      converted = (value - 32) * 5 / 9; // C = (F − 32) × 5/9
      unit = '°C';
    }

    setState(() {
      _errorText = null;
      _result = '${converted.toStringAsFixed(2)} $unit';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E88E5), Color(0xFF7C4DFF), Color(0xFFFF7043)],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            children: [
              const AppLogo(size: 88),
              const SizedBox(height: 14),
              const Text(
                'Temperature Converter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Convert °C and °F instantly',
                style: TextStyle(
                  color: Colors.white.withAlpha(220),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 26),

              // White card with the converter form
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Degrees
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _controller,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Degrees',
                              labelStyle: const TextStyle(color: kBlue),
                              errorText: _errorText,
                              errorMaxLines: 3,
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: kPurple, width: 2),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        // Type
                        Expanded(
                          flex: 2,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Type',
                              labelStyle: TextStyle(color: kBlue),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selected,
                                isExpanded: true,
                                isDense: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: kPurple,
                                ),
                                selectedItemBuilder: (context) => const [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '°C → °F',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '°F → °C',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                                items: const [
                                  DropdownMenuItem(
                                    value: cToF,
                                    child: Text(cToF),
                                  ),
                                  DropdownMenuItem(
                                    value: fToC,
                                    child: Text(fToC),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setState(() {
                                      _selected = v;
                                      _result = '';
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    // Result
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Result',
                        labelStyle: TextStyle(color: kBlue),
                      ),
                      child: Text(
                        _result.isEmpty ? '—' : _result,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: kOrange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Button
                    Container(
                      height: 54,
                      decoration: BoxDecoration(
                        gradient: kMainGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: kPurple.withAlpha(100),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _calculate,
                        icon: const Icon(Icons.swap_horiz, color: Colors.white),
                        label: const Text(
                          'Calculate',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
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

// ---------------------------------------------------------------------------
// About page
// ---------------------------------------------------------------------------
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Widget _infoTile(IconData icon, Color color, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F4FA),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header with photo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 36),
              decoration: const BoxDecoration(
                gradient: kMainGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/Myself.jpg',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                          width: 120,
                          height: 120,
                          color: const Color(0xFFE3E7FF),
                          child: const Icon(
                            Icons.person,
                            size: 70,
                            color: kPurple,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Md Belal Mondal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(45),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Flutter Developer',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _infoTile(Icons.person, kBlue, 'Developer', 'Md Belal Mondal'),
                  _infoTile(Icons.engineering, kOrange, 'Profession',
                      'Radio Electrical Artificer'),
                  _infoTile(Icons.code, kPurple, 'Developed by', 'HelloTech App'),
                  _infoTile(Icons.thermostat, Colors.red, 'App',
                      'Temperature Converter'),
                  _infoTile(Icons.flutter_dash, Colors.teal, 'Built with',
                      'Flutter'),
                  _infoTile(Icons.verified, Colors.green, 'Version', '1.0.0'),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
