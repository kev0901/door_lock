import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdviceSlip {
  late int id;
  late String advice;
  dynamic slip;

  AdviceSlip({
    required this.id,
    required this.advice,
  });

  AdviceSlip.fromJson(Map<String, dynamic> json) {
    slip = json['slip'];
    id = slip['id'];
    advice = slip['advice'].toString();
  }

  static Future<String> getAdvice() async {
    final url = Uri.parse('https://api.adviceslip.com/advice');
    final response = await http.get(url);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final adviceResponse = jsonDecode(response.body);
      AdviceSlip adviceClass = AdviceSlip.fromJson(adviceResponse);
      return adviceClass.advice;
    }
    return response.body;
  }
}

class AdviceCard extends StatelessWidget {
  AdviceCard({super.key});

  Future<String> advice = AdviceSlip.getAdvice();

  @override
  Widget build(BuildContext context) {
    Color quoteCardColor = Color.fromARGB(255, 194, 241, 3);
    double height = 180;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(
              left: 20,
              top: 20,
            ),
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  quoteCardColor.withOpacity(0.1),
                  quoteCardColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fortune cookie Text',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: advice,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Flexible(
                            child: Text(
                              snapshot.data!,
                              overflow: TextOverflow.visible,
                            ),
                          );
                        }
                        return const Text(
                          'Loading...',
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
