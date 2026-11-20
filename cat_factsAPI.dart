import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main(){
  runApp(CatFactsapi());
}
class CatFactsapi extends StatefulWidget {
  const CatFactsapi({super.key});

  @override
  State<CatFactsapi> createState() => _CatFactsapiState();
}

class _CatFactsapiState extends State<CatFactsapi> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CatFactAPI(),

    );

  }



}
class CatFactAPI extends StatefulWidget
{
  const CatFactAPI({super.key});


  @override
  State<CatFactAPI> createState() => _CatAPIState();
}

class _CatAPIState extends State<CatFactAPI> {

  String catFact = "Know Unknown thing about cat";
  bool isLoading = false;

  Future<void> getCatFact() async {
    setState(() {
      isLoading = true;
    });
    try {
      final url = Uri.parse("https://catfact.ninja/fact");
      final response = await http.get(
        url,
        headers: {"Accept": "application/json"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          catFact = data['fact'];
        });
      } else {
        throw Exception("API Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        catFact = "Error: $e";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F2),
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pets, size: 24),
            SizedBox(width: 8),
            Text(
              'Cat Facts',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepOrange.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 150,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepOrange,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.deepOrange.shade50,
                          child: const Icon(
                            Icons.pets,
                            size: 30,
                            color: Colors.deepOrange,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          catFact,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.6,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Characters: ${catFact.length}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange.shade700,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Fact copied!"),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy_rounded),
                              color: Colors.grey.shade600,
                              tooltip: "Copy Fact",
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : getCatFact,
                icon: const Icon(Icons.auto_awesome, size: 22),
                label: const Text(
                  "Get New Cat Fact",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}