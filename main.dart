import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  final title = 'download test';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //TODO: download state ...

            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: downloadAction,
                child: const Text('download'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> downloadAction() async {
    try {
      const String fileUrl = 'https://~s3파일URL';
      final String fileName = fileUrl.split('/').last;
      final Uri uri = Uri.parse(fileUrl);

      final response = await http.get(uri);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        String filePath = '${directory.path}/$fileName';

        // 파일 생성 및 데이터 쓰기
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        okAlert('success', 'downloaded > $fileName');
      }
    } catch (e) {
      print(e);
      okAlert('error', e.toString());
    }
  }

  void okAlert(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }
}
