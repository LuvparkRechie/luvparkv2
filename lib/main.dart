import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luvpark_get/custom_widgets/app_color.dart';
import 'package:luvpark_get/custom_widgets/custom_body.dart';
import 'package:luvpark_get/routes/pages.dart';
import 'package:luvpark_get/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyApp',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primaryColor,
          primary: AppColor.primaryColor,
        ),
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      children: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//       theme: ThemeData(
//         primaryColor: Colors.blue,
//       ),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final TextEditingController _searchController = TextEditingController();
//   final List<Map<String, String>> _items = [
//     {'title': 'John Doe', 'subtitle': 'Developer', 'address': '123 Main St'},
//     {'title': 'Jane Smith', 'subtitle': 'Designer', 'address': '456 Elm St'},
//     {'title': 'Sam Johnson', 'subtitle': 'Manager', 'address': '789 Oak St'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search and List'),
//         backgroundColor: Theme.of(context).primaryColor,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop(); // This will pop the current route
//           },
//         ),
//       ),
//       body: Container(
//         color: Colors.blue.shade50, // Light blue background for the body
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               _buildSearchField(),
//               SizedBox(height: 16),
//               Expanded(child: _buildList()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(48),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: _searchController,
//         decoration: InputDecoration(
//           hintText: 'Search...',
//           prefixIcon: Icon(Icons.search, color: Colors.blue),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(vertical: 15.0),
//         ),
//       ),
//     );
//   }

//   Widget _buildList() {
//     final query = _searchController.text.toLowerCase();
//     final filteredItems = _items.where((item) {
//       return item['title']!.toLowerCase().contains(query) ||
//           item['subtitle']!.toLowerCase().contains(query) ||
//           item['address']!.toLowerCase().contains(query);
//     }).toList();

//     return ListView.builder(
//       itemCount: filteredItems.length,
//       itemBuilder: (context, index) {
//         final item = filteredItems[index];
//         return ListTile(
//           contentPadding: EdgeInsets.symmetric(vertical: 10.0),
//           title: Text(
//             item['title']!,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//           subtitle: Text(item['subtitle']!),
//           trailing: Icon(Icons.chevron_right, color: Colors.blue),
//           onTap: () {
//             // Handle list item tap
//             print('Tapped on ${item['title']}');
//           },
//         );
//       },
//     );
//   }
// }
