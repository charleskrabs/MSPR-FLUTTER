import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Page Article',
      home: Article(),
    );
  }
}

class Article extends StatefulWidget {
  const Article({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  late Future<List<ArticleModel>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
      ),
      body: Center(
        child: FutureBuilder<List<ArticleModel>>(
          future: futureArticles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                Navigator.pushNamed(context, '/DetailArticle', 
                arguments: {"title": snapshot.data![index].title, "content": snapshot.data![index].description, "price": snapshot.data![index].price, "url_image": snapshot.data![index].url_image});
              },
                  child : Card(
                    child: ListTile(
                      title: Text(
                          snapshot.data![index].title ?? 'No title available'),
                      subtitle: Text(snapshot.data![index].description ??
                          'No description available'),
                      trailing: Text('\$${snapshot.data![index].price}'),
                      
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<List<ArticleModel>> fetchArticles() async {
    final response = await http
        .get(Uri.parse('https://9423-89-2-220-173.ngrok-free.app/products'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body) as List<dynamic>;
      return jsonResponse
          .map((article) => ArticleModel.fromJson(article))
          .toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}

class ArticleModel {
  final int id;
  final String? title;
  final String? description;
  final double? price;
  // ignore: non_constant_identifier_names
  final String? url_image;

  ArticleModel({
    required this.id,
    this.title,
    this.description,
    this.price,
    // ignore: non_constant_identifier_names
    this.url_image
  });
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      title: json['nom'] ?? 'No title available',
      description: json['description'] ?? 'No description available',
      price: json['prix'] ?? 0.0,
      url_image: json['url_image'] ?? ''
    );
  }
}
