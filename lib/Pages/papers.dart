import 'package:flutter/material.dart';
import 'package:nini/status.dart';
import 'package:nini/Widgets/articles.dart';

final List<Article> articles = [
  Article(
      name: "Mother",
      imgUrl: 'assets/images/01.jpg',
      review: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
  Article(
      name: "Baby",
      imgUrl: 'assets/images/02.jpg',
      review: "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
  Article(
      name: "Father",
      imgUrl: 'assets/images/03.jpg',
      review: "Veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip."),
  Article(
      name: "Aunt",
      imgUrl: 'assets/images/04.jpg',
      review: "Aliquam id diam maecenas ultricies mi eget mauris."),
  Article(
      name: "Father",
      imgUrl: 'assets/images/02.jpg',
      review: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
  Article(
      name: "Brother",
      imgUrl: 'assets/images/03.jpg',
      review: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
  Article(
      name: "Sister",
      imgUrl: 'assets/images/01.jpg',
      review: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
];


class Papers extends StatefulWidget {

  @override
  State<Papers> createState() => _Papers();
}

class _Papers extends State<Papers> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Pregnancy Articles"),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(10),
        itemCount: articles.length,
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemBuilder: (context, index) {
          final article = articles[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ArticleDetailPage(article: article)));
            },
            child: MyCard(
              name: article.name,
              imgUrl: article.imgUrl,
              review: article.review,
            ),
          );
        },
      ),
    );
      // This trailing comma makes auto-formatting nicer for build methods.
  }
}

class ArticleDetailPage extends StatelessWidget {
  final Article article;

  ArticleDetailPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(article.imgUrl, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 15),
            Text(article.name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(article.review, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}