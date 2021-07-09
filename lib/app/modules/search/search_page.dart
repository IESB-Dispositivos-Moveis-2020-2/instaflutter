import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:instaflutter/app/modules/search/search_store.dart';
import 'package:instaflutter/app/shared/loading_widget.dart';

class SearchPage extends StatefulWidget {
  final String title;
  const SearchPage({Key? key, this.title = 'Encontrar Pessoas'}) : super(key: key);
  @override
  SearchPageState createState() => SearchPageState();
}
class SearchPageState extends ModularState<SearchPage, SearchStore> {

  bool _searching = false;

  late final TextEditingController _searchController;


  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      final query = _searchController.text;
      store.search(query);
    });
  }

  Widget _searchField() {
    final color = Theme.of(context).buttonColor;
    return TextFormField(
      controller: _searchController,
      decoration: InputDecoration(
        icon: Icon(Icons.search, color: color),
        fillColor: color,
        focusColor: color,
        hoverColor: color,
      ),
      cursorColor: color,
      style: TextStyle(color: color),
    );
  }

  late Widget _searchingWidget = Observer(
    builder: (_) {
      return StreamBuilder(
        stream: store.searchResult,
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            log('Erro ao carregar: ${snapshot.error}');
            return Text('Deu erro!');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingWidget();
          }

          if (snapshot.hasData && snapshot.data!.docs.length > 0) {
            final users = snapshot.data!.docs;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                final user = users[index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: InkWell(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundImage: NetworkImage(user['profilePicture']),
                        ),
                        SizedBox(width: 12),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user['diplayName']),
                            Container(
                              width: MediaQuery.of(context).size.width - 24 - 64 - 12,
                              child: Text(
                                user['bio'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: true,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text(user['diplayName']),
                            content: Text('Deseja adicionar ${user['diplayName']}?'),
                            actions: [
                              TextButton(
                                child: Text('Não'),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              ElevatedButton(
                                child: Text('Sim'),
                                onPressed: () {
                                  store.add(user.id);
                                  Navigator.of(ctx).pop();
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          }
          return Container();
        },
      );
    },
  );
  
  late Widget _notSearching = StreamBuilder(
    stream: store.posts,
    builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        log('Erro ao carregar: ${snapshot.error}');
        return Text('Deu erro!');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return LoadingWidget();
      }
      
      if (snapshot.hasData && snapshot.data!.docs.length > 0) {
        final posts = snapshot.data!.docs;
        return GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          childAspectRatio: 1,
          children: posts.map((post) {
            final data = post.data() as Map<String, dynamic>;
            return Image.network(data['url'] as String, fit: BoxFit.cover);
          }).toList(),
        );
      }
      
      return Container(color: Colors.cyanAccent);
      
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searching ? _searchField() : Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(_searching ? Icons.close : Icons.search),
            onPressed: () {
             setState(() {
               _searching = !_searching;
             });
            },
          )
        ],
      ),
      body: _searching ? _searchingWidget : _notSearching,
    );
  }
}