import 'package:flutter/material.dart';
import '../data/get_feed_data.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticlePage extends StatefulWidget {
  final String feed;

  ArticlePage({Key key, this.feed}) : super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState(this.feed);
}

class _ArticlePageState extends State<ArticlePage> {
  final String feed;
  Future<List> articles;

  _ArticlePageState(this.feed);
  
  @override
  Widget build(BuildContext context) {
    GetFeedData rss = new GetFeedData();
    articles = rss.read(url: this.feed);

    return Scaffold(
      appBar: AppBar(
        title: Text('Articles List'),
        leading: Icon(Icons.rss_feed),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Padding(
            padding: EdgeInsets.only(bottom: 5, left:20),
            child: Row(
              children: <Widget>[
                Text(
                  this.feed,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.8)
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: articles,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return _messageTemplate(icon: Icons.refresh, title: 'Loading...');
            default:
              if(snapshot.hasError) {
                return _messageTemplate(icon: Icons.error, title: '${snapshot.error}');
              }
              return _listArticles(snapshot.data);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
    );
  }

  _messageTemplate({String title, IconData icon}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 80),
          Text('$title')
        ],
      ),
    );
  }

  _listArticles(List articles) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(articles[index]['title']),
                subtitle: Text(articles[index]['link']),
                leading: Icon(Icons.open_in_browser),
                onTap: () async{
                  _launchURL(url: articles[index]['link']);
                },
              );
            },
          ),
        )
      ],
    );
  }

  _launchURL({String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


}