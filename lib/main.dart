import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData _theme = AppTheme.lightTheme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SivaSakthi Stores',
      theme: _theme,
      home: SplashScreen(),
    );
  }
}

class AppTheme {
  static const Color primaryColor = Color(0xFF5C2D91);
  static const Color accentColor = Color(0xFFFF6B35);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color success = Color(0xFF28A745);
  static const Color danger = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17A2B8);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      background: backgroundColor,
      surface: cardColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(color: primaryColor),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: danger, width: 1),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: textPrimary),
      titleSmall: TextStyle(color: textSecondary),
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textPrimary),
      bodySmall: TextStyle(color: textSecondary),
      labelLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: textSecondary,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: primaryColor, width: 2),
        ),
      ),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    checkLoginStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    bool? isAdmin = prefs.getBool('isAdmin');

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(username: username, isAdmin: isAdmin)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor,
              Color(0xFF3A1D5B),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with error handling
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(75),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Image.asset(
                      'assets/jerry.gif',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading splash image: $error');
                        return Container(
                          color: Colors.white,
                          child: Icon(
                            Icons.store,
                            size: 80,
                            color: AppTheme.primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Sri SivaSakthi Stores',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Diwali Chits & More',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String? username;
  final bool? isAdmin;
  
  HomeScreen({this.username, this.isAdmin});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String shopName = "SivaSakthi Stores";
  final String ownerName = "Mr. Madhu Kumar";
  final String phoneNumber = "+91 9080660749";
  final String serviceDescription = "Specialized in Diwali Chits with various categories to choose from.";
  final String address = "SivaSakthi Stores, Konganapalli Road, Opposite to Aishwarya Hotel, Veppanapalli 635 121";
  final String mapUrl = "https://maps.app.goo.gl/44evAN22mo1KNfTc7";

  late List<Map<String, dynamic>> categories;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    // Add this to debug images after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _debugImages();
      setState(() {
        _isLoading = false;
      });
    });
  }

  List<Map<String, dynamic>> getCategories() {
    return [
      {
        "title": "Gold Category",
        "amount": "₹500 per month",
        "color": "blue",
        "products": [
          {"name": "Rice", "quantity": "25 Kg", "image": "assets/things/ricejpg.jpg"},
          {"name": "Maida", "quantity": "1 pack", "image": "assets/things/maida.jpg"},
          {"name": "Oil", "quantity": "5 liters", "image": "assets/things/oil.jpg"},
          {"name": "Wheat Flour", "quantity": "1 pack", "image": "assets/things/atta.jpg"},
          {"name": "White Dhall", "quantity": "3 Kg", "image": "assets/things/whitedall.jpg"},
          {"name": "Rice Raw", "quantity": "3 Kg", "image": "assets/things/riceraw.jpg"},
          {"name": "Semiya", "quantity": "1 pack", "image": "assets/things/semiya.jpg"},
          {"name": "Payasam Mix", "quantity": "1 pack", "image": "assets/things/payasam.jpg"},
          {"name": "Sugar", "quantity": "1 Kg", "image": "assets/things/sugar.jpg"},
          {"name": "Sesame Oil", "quantity": "150 grams", "image": "assets/things/sesame.jpg"},
          {"name": "Tamarind", "quantity": "25 pieces", "image": "assets/things/tamrind.jpg"},
          {"name": "Dry Chilli", "quantity": "25 pieces", "image": "assets/things/chilly.jpg"},
          {"name": "Coriander Seeds", "quantity": "11 pieces", "image": "assets/things/coriander.jpg"},
          {"name": "Salt", "quantity": "1/2 Kg", "image": "assets/things/salt.jpg"},
          {"name": "Jaggery", "quantity": "1/2 Kg", "image": "assets/things/jaggery.jpg"},
          {"name": "Pattasu Box", "quantity": "1 box", "image": "assets/things/pattasu.jpg"},
          {"name": "Matches Box", "quantity": "1 pack", "image": "assets/things/match.jpg"},
          {"name": "Turmeric Powder", "quantity": "1 pack", "image": "assets/things/tumeric.jpg"},
          {"name": "Kumkum", "quantity": "1 pack", "image": "assets/things/kumkumjpg.jpg"},
          {"name": "Camphor", "quantity": "1 pack", "image": "assets/things/camphor.jpg"}
        ],
      },
      {
        "title": "Silver Category",
        "amount": "₹300 per month",
        "color": "yellow",
        "products": [
          {"name": "Rice", "quantity": "5 Kg", "image": "assets/things/ricejpg.jpg"},
          {"name": "Oil", "quantity": "5 liters", "image": "assets/things/oil.jpg"},
          {"name": "White Dhall", "quantity": "5 Kg", "image": "assets/things/whitedall.jpg"},
          {"name": "Sesame Oil", "quantity": "250 grams", "image": "assets/things/sesame.jpg"},
          {"name": "Tamarind", "quantity": "25 pieces", "image": "assets/things/tamrind.jpg"},
          {"name": "Dry Chilli", "quantity": "25 pieces", "image": "assets/things/chilly.jpg"},
          {"name": "Coriander Seeds", "quantity": "11 pieces", "image": "assets/things/coriander.jpg"},
          {"name": "Maida", "quantity": "5 Kg", "image": "assets/things/maida.jpg"},
          {"name": "Wheat Flour", "quantity": "5 Kg", "image": "assets/things/atta.jpg"},
          {"name": "Oil", "quantity": "1/2 liter", "image": "assets/things/oil.jpg"},
          {"name": "Semiya", "quantity": "1 pack", "image": "assets/things/semiya.jpg"},
          {"name": "Matches Box", "quantity": "1 pack", "image": "assets/things/match.jpg"},
          {"name": "Turmeric Powder", "quantity": "1 pack", "image": "assets/things/tumeric.jpg"},
          {"name": "Kumkum", "quantity": "1 pack", "image": "assets/things/kumkumjpg.jpg"},
          {"name": "Camphor", "quantity": "1 pack", "image": "assets/things/camphor.jpg"}
        ],
      }
    ];
  }

  Future<void> _debugImages() async {
    for (var category in categories) {
      for (var product in category['products']) {
        try {
          await precacheImage(AssetImage(product['image']), context);
        } catch (e) {
          print('Failed to load: ${product['image']}, error: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(shopName),
        actions: [
          if (widget.username != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => widget.isAdmin == true
                          ? AdminScreen()
                          : UserScreen(username: widget.username!),
                    ),
                  );
                },
                icon: Icon(Icons.dashboard, size: 18),
                label: Text("Dashboard"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryColor,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                icon: Icon(Icons.login, size: 18),
                label: Text("Login"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryColor,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            categories = getCategories();
          });
          await _debugImages();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
              Container(
                height: 200,
                width: double.infinity,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/shop.jpg',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Icon(Icons.store, size: 80, color: Colors.grey[600]),
                        );
                      },
                    ),
                    
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 120,
                      right: 100,
                      top: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // People Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    

                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildPersonCard("Nanjappan", "Honoured", 'assets/father.jpg'),
                        buildPersonCard(ownerName, "Owner", 'assets/owner.jpg'),
                        buildPersonCard("Suselamma", "Honoured", 'assets/mother.jpg'),
                      ],
                    ),
                  ],
                ),
              ),

              // Address & Contact Section
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppTheme.primaryColor),
                        SizedBox(width: 8),
                        Text(
                          "Address",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      address,
                      style: TextStyle(fontSize: 15, height: 1.4),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                LocationPermission permission = await Geolocator.checkPermission();
                                if (permission == LocationPermission.denied) {
                                  permission = await Geolocator.requestPermission();
                                  if (permission == LocationPermission.denied) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Location permission denied')),
                                    );
                                    return;
                                  }
                                }
                                
                                if (permission == LocationPermission.deniedForever) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Location permission permanently denied')),
                                  );
                                  return;
                                }
                                
                                final Uri googleMapsUri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=Veppanapalli&destination_place_id=ChIJXbGmYHVdqzsRCLLuI0YpO_A');
                                if (await canLaunchUrl(googleMapsUri)) {
                                  await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
                                } else {
                                  final Uri webUri = Uri.parse('https://maps.app.goo.gl/44evAN22mo1KNfTc7');
                                  if (await canLaunchUrl(webUri)) {
                                    await launchUrl(webUri, mode: LaunchMode.externalApplication);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Could not open maps')),
                                    );
                                  }
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error opening maps: $e')),
                                );
                              }
                            },
                            icon: Icon(Icons.directions),
                            label: Text("Directions"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
                                if (await canLaunchUrl(phoneUri)) {
                                  await launchUrl(phoneUri);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Cannot open phone dialer')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error making phone call: $e')),
                                );
                              }
                            },
                            icon: Icon(Icons.phone),
                            label: Text("Call Us"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Service Description
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About Our Service",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        serviceDescription,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Categories Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Our Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: category["title"] == "Gold Category" 
                                      ? Color(0xFFFFD700).withOpacity(0.2)
                                      : Color(0xFFC0C0C0).withOpacity(0.2),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      category["title"] == "Gold Category" 
                                          ? Icons.star
                                          : Icons.star_half,
                                      color: category["title"] == "Gold Category" 
                                          ? Color(0xFFFFD700)
                                          : Color(0xFFC0C0C0),
                                      size: 28,
                                    ),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          category["title"],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          category["amount"],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CategoryDetailsPage(category: category),
                                          ),
                                        );
                                      },
                                      child: Text("View Products"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: category["title"] == "Gold Category" 
                                            ? Color(0xFFFFD700)
                                            : Color(0xFFC0C0C0),
                                        foregroundColor: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Featured Products:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          category["products"].length > 5 ? 5 : category["products"].length,
                                          (productIndex) {
                                            final product = category["products"][productIndex];
                                            return Container(
                                              width: 120,
                                              margin: EdgeInsets.only(right: 12),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Image.asset(
                                                      product["image"],
                                                      height: 80,
                                                      width: 120,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return Container(
                                                          height: 80,
                                                          width: 120,
                                                          color: Colors.grey[200],
                                                          child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    product["name"],
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    product["quantity"],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppTheme.textSecondary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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

  Widget buildPersonCard(String name, String role, String imagePath) {
    return Container(
      width: 100,
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath, 
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading person image: $imagePath - $error');
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            role,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class CategoryDetailsPage extends StatelessWidget {
  final Map<String, dynamic> category;

  const CategoryDetailsPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category['title']),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: category["title"] == "Gold Category" 
                  ? Color(0xFFFFD700).withOpacity(0.2)
                  : Color(0xFFC0C0C0).withOpacity(0.2),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category["title"] == "Gold Category" 
                        ? Icons.star
                        : Icons.star_half,
                    color: category["title"] == "Gold Category" 
                        ? Color(0xFFFFD700)
                        : Color(0xFFC0C0C0),
                    size: 32,
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category["title"],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      category["amount"],
                      style: TextStyle(
                        fontSize: 18,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Products Count
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  "Products",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${category['products'].length}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Products Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: category['products'].length,
                itemBuilder: (context, index) {
                  final product = category['products'][index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Image.asset(
                            product['image'],
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error loading product image: ${product['image']} - $error');
                              return Container(
                                height: 120,
                                width: double.infinity,
                                color: Colors.grey[200],
                                child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey[400]),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  product['quantity'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final response = await http.post(
          Uri.parse('https://nanjundeshwara.vercel.app/login'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'username': _userIdController.text, 
            'password': _passwordController.text
          }),
        );

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['success']) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('username', _userIdController.text);
            await prefs.setBool('isAdmin', data['isAdmin']);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(
                username: _userIdController.text, 
                isAdmin: data['isAdmin']
              )),
            );
          } else {
            _showErrorSnackBar('Invalid credentials');
          }
        } else {
          _showErrorSnackBar('Login failed. Please try again.');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('An error occurred: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.store,
                        size: 60,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Title
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Sign in to your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    
                    // User ID Field
                    TextFormField(
                      controller: _userIdController,
                      decoration: InputDecoration(
                        labelText: 'User ID',
                        hintText: 'Enter your user ID',
                        prefixIcon: Icon(Icons.person),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Please enter your user ID' : null,
                    ),
                    SizedBox(height: 16),
                    
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                        prefixIcon: Icon(Icons.phone_android),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      obscureText: _obscurePassword,
                      validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                    ),
                    SizedBox(height: 24),
                    
                    // Login Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text('Login'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Back to Home
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back to Home'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdminScreen extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Admin Header
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        Color(0xFF3A1D5B),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.admin_panel_settings,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, Admin!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Manage your store operations',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                
                // Admin Actions
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                
                // Admin Cards Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildAdminActionCard(
                      context,
                      'Operations',
                      Icons.settings,
                      Colors.blue,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminOperationsScreen()),
                        );
                      },
                    ),
                    _buildAdminActionCard(
                      context,
                      'Pending Payments',
                      Icons.payment,
                      Colors.green,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminPaymentApprovalScreen()),
                        );
                      },
                    ),
                    _buildAdminActionCard(
                      context,
                      'Trash',
                      Icons.delete,
                      Colors.red,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TrashScreen()),
                        );
                      },
                    ),
                    _buildAdminActionCard(
                      context,
                      'Logout',
                      Icons.logout,
                      Colors.grey,
                      () => _logout(context),
                    ),
                  ],
                ),
                
                SizedBox(height: 24),
                
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminActionCard(
    BuildContext context, 
    String title, 
    IconData icon, 
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class TrashScreen extends StatefulWidget {
  @override
  _TrashScreenState createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  List<Map<String, dynamic>> _deletedUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDeletedUsers();
  }

  Future<void> _fetchDeletedUsers() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/deleted_users'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _deletedUsers = List<Map<String, dynamic>>.from(data['users']);
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch deleted users: ${response.body}'),
            backgroundColor: AppTheme.danger,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _restoreUser(int userId) async {
    try {
      final response = await http.put(
        Uri.parse('https://nanjundeshwara.vercel.app/restore_user/$userId'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User restored successfully'),
            backgroundColor: AppTheme.success,
          ),
        );
        _fetchDeletedUsers(); // Refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to restore user: ${response.body}'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  Future<void> _permanentlyDeleteUser(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('https://nanjundeshwara.vercel.app/permanent_delete_user/$userId'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User permanently deleted'),
            backgroundColor: AppTheme.success,
          ),
        );
        _fetchDeletedUsers(); // Refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to permanently delete user: ${response.body}'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  void _showDeleteConfirmationDialog(int userId, String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permanently Delete User'),
          content: Text(
            'Are you sure you want to permanently delete $userName (ID: $userId)? This action cannot be undone.'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _permanentlyDeleteUser(userId);
              },
              child: Text(
                'Delete Permanently',
                style: TextStyle(color: AppTheme.danger),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trash'),
        backgroundColor: AppTheme.danger,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _deletedUsers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No deleted users found',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchDeletedUsers,
                  child: ListView.builder(
                    itemCount: _deletedUsers.length,
                    itemBuilder: (context, index) {
                      final user = _deletedUsers[index];
                      final deletedAt = user['deletedAt'] != null 
                          ? DateTime.parse(user['deletedAt']).toString().substring(0, 16)
                          : 'Unknown';
                      
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.danger.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.person_off,
                                      color: AppTheme.danger,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${user['c_name']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'ID: ${user['_id']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Divider(),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildInfoRow(Icons.location_on, 'Village', '${user['c_vill']}'),
                                        SizedBox(height: 8),
                                        _buildInfoRow(Icons.category, 'Category', '${user['c_category']}'),
                                        SizedBox(height: 8),
                                        _buildInfoRow(Icons.phone, 'Phone', '${user['phone']}'),
                                        SizedBox(height: 8),
                                        _buildInfoRow(Icons.calendar_today, 'Deleted on', deletedAt),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.restore, color: AppTheme.success),
                                        onPressed: () => _restoreUser(user['_id']),
                                        tooltip: 'Restore User',
                                      ),
                                      SizedBox(height: 8),
                                      IconButton(
                                        icon: Icon(Icons.delete_forever, color: AppTheme.danger),
                                        onPressed: () => _showDeleteConfirmationDialog(user['_id'], user['c_name']),
                                        tooltip: 'Delete Permanently',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textSecondary,
        ),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class AdminPaymentApprovalScreen extends StatefulWidget {
  @override
  _AdminPaymentApprovalScreenState createState() => _AdminPaymentApprovalScreenState();
}

class _AdminPaymentApprovalScreenState extends State<AdminPaymentApprovalScreen> {
  List<Map<String, dynamic>> _pendingTransactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPendingTransactions();
  }

  Future<void> _fetchPendingTransactions() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final url = Uri.parse('https://nanjundeshwara.vercel.app/pending_transactions');
      print('Sending request to: $url');

      final response = await http.get(url);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final transactions = json.decode(response.body);
        print('Transactions found: ${transactions.length}');
        setState(() {
          _pendingTransactions = List<Map<String, dynamic>>.from(transactions);
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch pending transactions: ${response.body}'),
            backgroundColor: AppTheme.danger,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _approvePayment(String transactionId) async {
    try {
      final response = await http.post(
        Uri.parse('https://nanjundeshwara.vercel.app/approve_payment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'transactionId': transactionId}),
      );
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment approved successfully'),
            backgroundColor: AppTheme.success,
          ),
        );
      _fetchPendingTransactions();

      // if (response.statusCode == 200) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Payment approved successfully'),
      //       backgroundColor: AppTheme.success,
      //     ),
      //   );
      //   _fetchPendingTransactions();
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Failed to approve payment: ${response.body}'),
      //       backgroundColor: AppTheme.danger,
      //     ),
      //   );
      // }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  Future<void> _rejectPayment(String transactionId) async {
    try {
      final response = await http.post(
        Uri.parse('https://nanjundeshwara.vercel.app/reject_payment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'transactionId': transactionId}),
      );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment rejected'),
            backgroundColor: AppTheme.warning,
          ),
        );
        _fetchPendingTransactions();
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Payments'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _pendingTransactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.payment_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No pending payment requests',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchPendingTransactions,
                  child: ListView.builder(
                    itemCount: _pendingTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _pendingTransactions[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppTheme.warning.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.payment,
                                      color: AppTheme.warning,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Payment Request',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'User ID: ${transaction['userId']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppTheme.warning.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      'Pending',
                                      style: TextStyle(
                                        color: AppTheme.warning,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Divider(),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildPaymentInfoRow('Month', transaction['month']),
                                        SizedBox(height: 8),
                                        _buildPaymentInfoRow('Amount', '₹${transaction['amount']}'),
                                        SizedBox(height: 8),
                                        _buildPaymentInfoRow('Transaction ID', transaction['transactionId']),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _rejectPayment(transaction['transactionId']),
                                      icon: Icon(Icons.close),
                                      label: Text('Reject'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppTheme.danger,
                                        side: BorderSide(color: AppTheme.danger),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _approvePayment(transaction['transactionId']),
                                      icon: Icon(Icons.check),
                                      label: Text('Approve'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.success,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildPaymentInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class AdminOperationsScreen extends StatefulWidget {
  @override
  _AdminOperationsScreenState createState() => _AdminOperationsScreenState();
}

class _AdminOperationsScreenState extends State<AdminOperationsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _villageController = TextEditingController();
  String _selectedCategory = 'Gold';
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _monthController = TextEditingController();
  final _searchController = TextEditingController();

  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _payments = [];
  List<Map<String, dynamic>> _paidUsers = [];
  List<Map<String, dynamic>> _unpaidUsers = [];
  List<String> _villages = [];
  String _selectedVillage = '';
  List<Map<String, dynamic>> _villageUsers = [];
  List<Map<String, dynamic>> _inactiveUsers = [];

  String _selectedOperation = '';
  Map<String, dynamic> _userToDelete = {};

  List<String> categories = ['Gold', 'Silver', 'Bronze'];

  @override
  void dispose() {
    _userIdController.dispose();
    _nameController.dispose();
    _villageController.dispose();
    _phoneController.dispose();
    _amountController.dispose();
    _monthController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchVillages() async {
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/get_all_villages'),
      );

      if (response.statusCode == 200) {
        final villages = json.decode(response.body);
        setState(() {
          _villages = List<String>.from(villages.map((v) => v['v_name']));
          if (_villages.isNotEmpty && _selectedVillage.isEmpty) {
            _selectedVillage = _villages[0];
          }
        });
      } else {
        _showErrorSnackBar('Failed to fetch villages: ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  Future<void> _searchByVillage() async {
    if (_selectedVillage.isEmpty) {
      _showErrorSnackBar('Please select a village');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/search_by_village?village=${_selectedVillage}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _villageUsers = List<Map<String, dynamic>>.from(data['users']);
        });
      } else {
        _showErrorSnackBar('Failed to search by village: ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  Future<void> _fetchInactiveCustomers() async {
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/inactive_customers'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _inactiveUsers = List<Map<String, dynamic>>.from(data['inactiveUsers']);
        });
      } else {
        _showErrorSnackBar('Failed to fetch inactive customers: ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  Future<void> _addUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('https://nanjundeshwara.vercel.app/add_user'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'userId': int.parse(_userIdController.text),
            'c_name': _nameController.text,
            'c_vill': _villageController.text,
            'c_category': _selectedCategory,
            'phone': _phoneController.text,
          }),
        );

          _showSuccessSnackBar('User added successfully');
          _clearForm();

      } catch (e) {
        _showErrorSnackBar('An error occurred: $e');
      }
    }
  }

  Future<void> _fetchUserDetailsForDeletion() async {
    if (_userIdController.text.isEmpty) {
      _showErrorSnackBar('Please enter a user ID to delete');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/find_user?userId=${_userIdController.text}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _userToDelete = json.decode(response.body);
        });
        
        // Show confirmation dialog
        _showDeleteConfirmationDialog();
      } else {
        _showErrorSnackBar('Failed to fetch user details: ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to move this user to trash?'),
              SizedBox(height: 20),
              Text('User Details:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('ID: ${_userToDelete['_id']}'),
              Text('Name: ${_userToDelete['c_name']}'),
              Text('Village: ${_userToDelete['c_vill']}'),
              Text('Category: ${_userToDelete['c_category']}'),
              Text('Phone Number: ${_userToDelete['phone']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteUser();
              },
              child: Text(
                'Move to Trash',
                style: TextStyle(color: AppTheme.danger),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser() async {
    try {
      final response = await http.delete(
        Uri.parse('https://nanjundeshwara.vercel.app/delete_user/${_userIdController.text}'),
      );

      if (response.statusCode == 200) {
        _showSuccessSnackBar('User moved to trash');
        _clearForm();
      } else {
        _showErrorSnackBar('Failed to delete user: ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  Future<void> _viewAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/find_all_users'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _users = List<Map<String, dynamic>>.from(data['users']);
        });
      } else {
        _showErrorSnackBar('Failed to fetch users: ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  Future<void> _addPayment() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('https://nanjundeshwara.vercel.app/add_payments'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'c_id': int.parse(_userIdController.text),
            'p_month': _monthController.text,
            'amount': double.parse(_amountController.text),
          }),
        );

          _showSuccessSnackBar('Payment added successfully');
      } catch (e) {
        
      }
    }
  }

  Future<void> _viewPayments() async {
    if (_userIdController.text.isEmpty) {
      _showErrorSnackBar('Please enter a user ID to view payments');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/find_payments?userIdPayments=${_userIdController.text}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _payments = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        _showErrorSnackBar('Failed to fetch payments: ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  Future<void> _viewPaymentsByMonth() async {
    if (_monthController.text.isEmpty) {
      _showErrorSnackBar('Please enter a month to view payments');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/view_payments_by_month?p_month=${_monthController.text}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _paidUsers = List<Map<String, dynamic>>.from(data['paidUsers']);
          _unpaidUsers = List<Map<String, dynamic>>.from(data['unpaidUsers']);
        });
      } else {
        _showErrorSnackBar('Failed to fetch payments: ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  Future<void> _fetchUserDetails() async {
    if (_userIdController.text.isEmpty) {
      return;
    }
    
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/find_user?userId=${_userIdController.text}'),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          _nameController.text = userData['c_name'];
          _selectedCategory = userData['c_category'];
          switch (_selectedCategory) {
            case 'Gold':
              _amountController.text = '500';
              break;
            case 'Silver':
              _amountController.text = '300';
              break;
            default:
              _amountController.text = '';
          }
        });
      } else {
        _showErrorSnackBar('Failed to fetch user details: ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  void _clearForm() {
    _userIdController.clear();
    _nameController.clear();
    _villageController.clear();
    _selectedCategory = 'Gold';
    _phoneController.clear();
    _amountController.clear();
    _monthController.clear();
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Operations'),
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 100,
            color: Colors.grey[100],
            child: ListView(
              padding: EdgeInsets.all(12),
              children: [
                _buildOperationButton('Add\nUser', Icons.person_add),
                _buildOperationButton('Delete\nUser', Icons.person_remove),
                _buildOperationButton('View\nAll\nUsers', Icons.people),
                _buildOperationButton('Add\nPayment', Icons.payment),
                _buildOperationButton('View\nPayments', Icons.receipt),
                _buildOperationButton('View\nPayments\nby\nMonth', Icons.calendar_month),
                _buildOperationButton('Search\nBy\nVillage', Icons.location_city),
                _buildOperationButton('Inactive\nCustomers', Icons.person_off),
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: _selectedOperation.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.touch_app,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Select an operation from the sidebar',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _buildOperationContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationButton(String operation, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedOperation = operation;
            _clearForm();
            
            // Initialize data for specific operations
            if (operation == 'Search\nBy\nVillage') {
              _fetchVillages();
            } else if (operation == 'Inactive\nCustomers') {
              _fetchInactiveCustomers();
            } else if (operation == 'View\nAll\nUsers') {
              _viewAllUsers();
            }
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedOperation == operation 
              ? AppTheme.primaryColor 
              : Colors.white,
          foregroundColor: _selectedOperation == operation 
              ? Colors.white 
              : AppTheme.textPrimary,
          elevation: _selectedOperation == operation ? 4 : 1,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24),
            SizedBox(height: 8),
            Text(
              operation.replaceAll('\n', ' '),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationContent() {
    switch (_selectedOperation) {
      case 'Add\nUser':
        return _buildAddUserForm();
      case 'Delete\nUser':
        return _buildDeleteUserForm();
      case 'View\nAll\nUsers':
        return _buildViewAllUsersContent();
      case 'Add\nPayment':
        return _buildAddPaymentForm();
      case 'View\nPayments':
        return _buildViewPaymentsContent();
      case 'View\nPayments\nby\nMonth':
        return _buildViewPaymentsByMonthContent();
      case 'Search\nBy\nVillage':
        return _buildSearchByVillageContent();
      case 'Inactive\nCustomers':
        return _buildInactiveCustomersContent();
      default:
        return Container();
    }
  }

Widget _buildAddUserForm() {
  return Card(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Prevent unnecessary space
            children: [
              Text(
                'Add New User',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _userIdController,
                decoration: InputDecoration(
                  labelText: 'User ID',
                  prefixIcon: Icon(Icons.badge),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter user ID' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _villageController,
                decoration: InputDecoration(
                  labelText: 'Village',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter village' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Please enter phone number' : null,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addUser,
                  icon: Icon(Icons.add),
                  label: Text('Add User'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


  Widget _buildDeleteUserForm() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delete User',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _userIdController,
              decoration: InputDecoration(
                labelText: 'User ID',
                prefixIcon: Icon(Icons.badge),
                hintText: 'Enter the ID of the user to delete',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _fetchUserDetailsForDeletion,
                icon: Icon(Icons.delete),
                label: Text('Move User to Trash'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.danger,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewAllUsersContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'All Users',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _viewAllUsers,
              icon: Icon(Icons.refresh),
              label: Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.info,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        if (_users.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Total Users: ${_users.length}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        SizedBox(height: 16),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search Users',
            prefixIcon: Icon(Icons.search),
            hintText: 'Search by name, village, category or ID',
          ),
          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                _viewAllUsers();
              } else {
                _users = _users.where((user) =>
                  user['c_name'].toString().toLowerCase().contains(value.toLowerCase()) ||
                  user['c_vill'].toString().toLowerCase().contains(value.toLowerCase()) ||
                  user['c_category'].toString().toLowerCase().contains(value.toLowerCase()) ||
                  user['_id'].toString().contains(value)
                ).toList();
              }
            });
          },
        ),
        SizedBox(height: 16),
        Expanded(
          child: _users.isEmpty
              ? Center(
                  child: Text(
                    'No users found',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                          child: Text(
                            user['c_name'].substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          '${user['_id']} - ${user['c_name']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Village: ${user['c_vill']}, Category: ${user['c_category']}'),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Payments: ${user['paymentCount']}',
                            style: TextStyle(
                              color: AppTheme.info,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAddPaymentForm() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Payment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _userIdController,
                decoration: InputDecoration(
                  labelText: 'User ID',
                  prefixIcon: Icon(Icons.badge),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter user ID' : null,
                onChanged: (_) => _fetchUserDetails(),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                readOnly: true,
                enabled: false,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter amount' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _monthController,
                decoration: InputDecoration(
                  labelText: 'Month (MM format)',
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: 'e.g. 01 for January',
                ),
                validator: (value) => value!.isEmpty ? 'Please enter month' : null,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addPayment,
                  icon: Icon(Icons.add),
                  label: Text('Add Payment'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewPaymentsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'View Payments',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _userIdController,
          decoration: InputDecoration(
            labelText: 'User ID',
            prefixIcon: Icon(Icons.badge),
            hintText: 'Enter user ID to view their payments',
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _viewPayments,
            icon: Icon(Icons.search),
            label: Text('View Payments'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: _payments.isEmpty
              ? Center(
                  child: Text(
                    'No payments found',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _payments.length,
                  itemBuilder: (context, index) {
                    final payment = _payments[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.success.withOpacity(0.1),
                          child: Icon(
                            Icons.payment,
                            color: AppTheme.success,
                          ),
                        ),
                        title: Text(
                          'Amount: ₹${payment['amount']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Month: ${payment['p_month']}, User: ${payment['c_name']}'),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildViewPaymentsByMonthContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'View Payments by Month',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _monthController,
          decoration: InputDecoration(
            labelText: 'Month (MM format)',
            prefixIcon: Icon(Icons.calendar_today),
            hintText: 'e.g. 01 for January',
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _viewPaymentsByMonth,
            icon: Icon(Icons.search),
            label: Text('View Payments by Month'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        SizedBox(height: 20),
        if (_paidUsers.isNotEmpty || _unpaidUsers.isNotEmpty)
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TabBar(
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, size: 18),
                              SizedBox(width: 8),
                              Text('Paid (${_paidUsers.length})'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cancel, size: 18),
                              SizedBox(width: 8),
                              Text('Unpaid (${_unpaidUsers.length})'),
                            ],
                          ),
                        ),
                      ],
                      indicatorColor: AppTheme.primaryColor,
                      labelColor: AppTheme.primaryColor,
                      unselectedLabelColor: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Paid Users Tab
                        _buildUserList(_paidUsers, true),
                        // Unpaid Users Tab
                        _buildUserList(_unpaidUsers, false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserList(List<Map<String, dynamic>> users, bool isPaid) {
    return users.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isPaid ? Icons.check_circle_outline : Icons.error_outline,
                  size: 48,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  isPaid ? 'No paid users found' : 'No unpaid users found',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isPaid 
                        ? AppTheme.success.withOpacity(0.1)
                        : AppTheme.danger.withOpacity(0.1),
                    child: Icon(
                      isPaid ? Icons.check : Icons.close,
                      color: isPaid ? AppTheme.success : AppTheme.danger,
                    ),
                  ),
                  title: Text(
                    'ID: ${user['_id']} - ${user['c_name']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('Village: ${user['c_vill']}, Category: ${user['c_category']}, Phone: ${user['number']}'),
                  trailing: isPaid
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '₹${user['amount']}',
                            style: TextStyle(
                              color: AppTheme.success,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                ),
              );
            },
          );
  }

  Widget _buildSearchByVillageContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search By Village',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButton<String>(
            value: _selectedVillage.isNotEmpty ? _selectedVillage : null,
            hint: Text('Select Village'),
            isExpanded: true,
            underline: SizedBox(),
            items: _villages.map((String village) {
              return DropdownMenuItem<String>(
                value: village,
                child: Text(village),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedVillage = newValue!;
              });
            },
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _searchByVillage,
            icon: Icon(Icons.search),
            label: Text('Search'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        SizedBox(height: 20),
        if (_villageUsers.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Customers in $_selectedVillage: ${_villageUsers.length}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        SizedBox(height: 16),
        Expanded(
          child: _villageUsers.isEmpty
              ? Center(
                  child: Text(
                    'No users found in this village',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _villageUsers.length,
                  itemBuilder: (context, index) {
                    final user = _villageUsers[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                          child: Text(
                            user['c_name'].substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          'ID: ${user['_id']} - ${user['c_name']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Category: ${user['c_category']}'),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Payments: ${user['paymentCount']}',
                            style: TextStyle(
                              color: AppTheme.info,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildInactiveCustomersContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Inactive Customers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _fetchInactiveCustomers,
              icon: Icon(Icons.refresh),
              label: Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.info,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        if (_inactiveUsers.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.danger.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Inactive Customers: ${_inactiveUsers.length}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.danger,
              ),
            ),
          ),
        SizedBox(height: 16),
        Expanded(
          child: _inactiveUsers.isEmpty
              ? Center(
                  child: Text(
                    'No inactive customers found',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _inactiveUsers.length,
                  itemBuilder: (context, index) {
                    final user = _inactiveUsers[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.danger.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person_off,
                                    color: AppTheme.danger,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ID: ${user['id']} - ${user['name']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Phone: ${user['phone']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Divider(),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInfoRow(Icons.location_on, 'Village', '${user['village']}'),
                                      SizedBox(height: 8),
                                      _buildInfoRow(Icons.category, 'Category', '${user['category']}'),
                                      SizedBox(height: 8),
                                      _buildInfoRow(Icons.calendar_today, 'Last Payment', '${user['lastPaymentMonth']}'),
                                      SizedBox(height: 8),
                                      _buildInfoRow(Icons.currency_rupee, 'Last Amount', '₹${user['lastPaymentAmount']}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textSecondary,
        ),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class UserScreen extends StatefulWidget {
  final String username;

  UserScreen({required this.username});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Map<String, dynamic> _userDetails = {};
  List<Map<String, dynamic>> _payments = [];
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    
    await Future.wait([
      _fetchUserDetails(),
      _fetchPayments(),
      _fetchNotifications(),
    ]);
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchUserDetails() async {
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/find_user?userId=${widget.username}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _userDetails = json.decode(response.body);
        });
      } else {
        _showErrorSnackBar('Failed to fetch user details: ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  Future<void> _fetchPayments() async {
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/find_payments?userIdPayments=${widget.username}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _payments = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        _showErrorSnackBar('Failed to fetch payments: ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  Future<void> _fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/notifications/${widget.username}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _notifications = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        _showErrorSnackBar('Failed to fetch notifications: ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('User Dashboard'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('User Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen(notifications: _notifications)),
              );
            },
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: Icon(Icons.payment),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentScreen(username: widget.username)),
              );
            },
            tooltip: 'Make Payment',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Profile Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  _userDetails['c_name'] != null && _userDetails['c_name'].isNotEmpty
                                      ? _userDetails['c_name'][0].toUpperCase()
                                      : 'U',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome, ${_userDetails['c_name'] ?? widget.username}!',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'User ID: ${_userDetails['_id'] ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(),
                        SizedBox(height: 12),
                        _buildUserInfoRow(Icons.location_on, 'Village', _userDetails['c_vill'] ?? 'N/A'),
                        SizedBox(height: 8),
                        _buildUserInfoRow(Icons.phone, 'Phone', _userDetails['phone'] ?? 'N/A'),
                        SizedBox(height: 8),
                        _buildUserInfoRow(
                          Icons.category,
                          'Category',
                          _userDetails['c_category'] ?? 'N/A',
                          _userDetails['c_category'] == 'Gold'
                              ? Color(0xFFFFD700)
                              : Color(0xFFC0C0C0),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Payment History Section
                Text(
                  'Payment History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                
                _payments.isEmpty
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.receipt_long,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No payments found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _payments.length,
                        itemBuilder: (context, index) {
                          final payment = _payments[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppTheme.success.withOpacity(0.1),
                                child: Icon(
                                  Icons.payment,
                                  color: AppTheme.success,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                'Amount: ₹${payment['amount']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text('Month: ${payment['p_month']}'),
                              trailing: Icon(Icons.check_circle, color: AppTheme.success),
                            ),
                          );
                        },
                      ),
                
                SizedBox(height: 24),
                
                // Quick Actions
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildActionCard(
                        'Make Payment',
                        Icons.payment,
                        AppTheme.success,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PaymentScreen(username: widget.username)),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildActionCard(
                        'Notifications',
                        Icons.notifications,
                        AppTheme.warning,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NotificationsScreen(notifications: _notifications)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionCard(
                        'View Categories',
                        Icons.category,
                        AppTheme.info,
                        () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildActionCard(
                        'Logout',
                        Icons.logout,
                        Colors.grey,
                        () => _logout(context),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(IconData icon, String label, String value, [Color? valueColor]) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.textSecondary,
        ),
        SizedBox(width: 12),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppTheme.textPrimary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notifications;

  NotificationsScreen({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final DateTime createdAt = DateTime.parse(notification['createdAt']);
                final String formattedDate = '${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
                
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.notifications,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      notification['message'],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  final String username;

  PaymentScreen({required this.username});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _transactionIdController = TextEditingController();
  bool _isPaid = false;
  bool _isLoading = true;
  Map<String, dynamic> _userDetails = {};
  String _selectedMonth = '01';
  List<String> _months = [];

  @override
  void initState() {
    super.initState();
    _initializeMonths();
    _fetchUserDetails();
  }

  void _initializeMonths() {
    _months = List.generate(12, (index) {
      return (index + 1).toString().padLeft(2, '0');
    });
  }

  @override
  void dispose() {
    _transactionIdController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/find_user?userId=${widget.username}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _userDetails = json.decode(response.body);
        });
        await _checkPaymentStatus();
      } else {
        _showErrorSnackBar('Failed to fetch user details: ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkPaymentStatus() async {
    try {
      final url = Uri.parse(
        'https://nanjundeshwara.vercel.app/check_payment_status?userId=${widget.username}&month=$_selectedMonth',
      );
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _isPaid = data['isPaid'];
        });
      } else {
        _showErrorSnackBar('Failed to check payment status: ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  Future<void> _requestPayment() async {
    if (_transactionIdController.text.isEmpty) {
      _showErrorSnackBar('Please enter a transaction ID');
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await http.post(
        Uri.parse('https://nanjundeshwara.vercel.app/request_payment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': int.parse(widget.username),
          'month': _selectedMonth,
          'amount': _userDetails['c_category'] == 'Gold' ? 500 : 300,
          'transactionId': _transactionIdController.text,
        }),
      );

      
        _showSuccessSnackBar('Payment request submitted successfully');
        _transactionIdController.clear();
        await _checkPaymentStatus();
      
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getMonthName(String monthNumber) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final index = int.parse(monthNumber) - 1;
    return months[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Payment'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month Selection Card
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Month',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: DropdownButton<String>(
                              value: _selectedMonth,
                              isExpanded: true,
                              underline: SizedBox(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedMonth = newValue!;
                                });
                                _checkPaymentStatus();
                              },
                              items: _months.map((String month) {
                                return DropdownMenuItem<String>(
                                  value: month,
                                  child: Text('${_getMonthName(month)} (${month})'),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Payment Status Card
                  _isPaid
                      ? Card(
                          elevation: 2,
                          color: AppTheme.success.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: AppTheme.success,
                                  size: 48,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Payment Already Made',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.success,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'You have already made the payment for ${_getMonthName(_selectedMonth)}.',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppTheme.warning.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.payment,
                                        color: AppTheme.warning,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Payment Required',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'For ${_getMonthName(_selectedMonth)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppTheme.warning.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        'Pending',
                                        style: TextStyle(
                                          color: AppTheme.warning,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Divider(),
                                SizedBox(height: 20),
                                
                                // QR Code Section
                                Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 200,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.asset(
                                            'assets/things/qr.jpg',
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              print('Error loading QR code image: $error');
                                              return Container(
                                                color: Colors.grey[200],
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.qr_code, size: 48, color: Colors.grey[600]),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      'QR Code not available',
                                                      style: TextStyle(color: Colors.grey[600]),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Scan to Pay',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Amount: ₹${_userDetails['c_category'] == 'Gold' ? '500' : '300'}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.success,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                SizedBox(height: 24),
                                
                                // Transaction ID Field
                                TextFormField(
                                  controller: _transactionIdController,
                                  decoration: InputDecoration(
                                    labelText: 'Transaction ID',
                                    hintText: 'Enter your payment transaction ID',
                                    prefixIcon: Icon(Icons.receipt),
                                  ),
                                ),
                                SizedBox(height: 20),
                                
                                // Submit Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _requestPayment,
                                    icon: Icon(Icons.send),
                                    label: Text('Submit Payment'),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Note: Your payment will be verified by the admin before it is marked as paid.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
