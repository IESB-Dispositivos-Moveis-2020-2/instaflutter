import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaflutter/app/constants.dart';
import 'package:instaflutter/app/modules/profile/profile_store.dart';
import 'package:instaflutter/app/shared/loading_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  ProfilePageState createState() => ProfilePageState();
}
class ProfilePageState extends ModularState<ProfilePage, ProfileStore> {

  final padding = EdgeInsets.only(left: 16, right: 16, top: 16);

  late final ImagePicker _picker;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(builder: (_) {
          return Text(store.user?.displayName ?? 'Sem nome');
        }),
        actions: [
          Observer(builder: (_) {
            if (store.loading) {
              return Container(
                child: Center(
                  child: Transform.scale(
                    scale: 0.5,
                    child: CircularProgressIndicator(color: Theme.of(context).buttonColor),
                  ),
                ),
              );
            }
            return IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: () {
                showModalBottomSheet(context: context, builder: (context) {
                  return Container(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          child: Row(
                            children: [
                              Icon(Icons.camera_alt_outlined),
                              SizedBox(width: 16),
                              Text('Tirar Foto')
                            ],
                          ),
                          onTap: () async {
                            final pickedPhoto = await _picker.getImage(
                                source: ImageSource.camera,
                                imageQuality: 50,
                                maxWidth: 1920,
                                maxHeight: 1200
                            );
                            if (pickedPhoto != null) {
                              store.postPicture(pickedPhoto.path);
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                        SizedBox(height: 24),
                        InkWell(
                          child: Row(
                            children: [
                              Icon(Icons.photo_library_outlined),
                              SizedBox(width: 16),
                              Text('Escolher Foto')
                            ],
                          ),
                          onTap: () async {
                            final pickedPhoto = await _picker.getImage(
                                source: ImageSource.gallery,
                                imageQuality: 50,
                                maxWidth: 1920,
                                maxHeight: 1200
                            );
                            if (pickedPhoto != null) {
                              store.postPicture(pickedPhoto.path);
                            }
                            Navigator.of(context).pop();
                          },
                        ),

                      ],
                    ),
                  );
                });
              },
            );
          })
        ],
      ),
      body: ListView(
        children: <Widget>[
          _UserHeader(padding: padding, store: store),
          _UserSubhead(padding: padding, store: store),
          _UserGallery(padding: padding, store: store),
        ],
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {

  EdgeInsets padding;
  ProfileStore store;
  _UserHeader({required this.padding, required this.store});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 40,
            child: Observer(builder: (_) {
              if (store.user == null) {
                return LoadingWidget();
              }
              if (store.user!.photoURL != null && store.user!.photoURL!.isNotEmpty) {
                return CircleAvatar(
                  radius: 38,
                  backgroundImage: NetworkImage(store.user!.photoURL!),
                );
              }
              return CircleAvatar(
                radius: 38,
                backgroundImage: AssetImage('assets/sem-foto.jpg'),
              );
            }),
          ),
          Column(
            children: [
              Observer(builder: (_) => Text('${store.postsCount ?? 0}', style: TextStyle(fontWeight: FontWeight.bold))),
              Text('${(store.postsCount ?? 0) > 1 ? 'Publicações' : 'Publicação'}')
            ],
          ),
          Column(
            children: [
              Observer(builder: (_) => Text('${store.followers ?? 0}', style: TextStyle(fontWeight: FontWeight.bold))),
              Text('${(store.following ?? 0) > 1 ? 'Seguidores' : 'Seguidor'}')
            ],
          ),
          Column(
            children: [
              Observer(builder: (_) => Text('${store.following ?? 0}', style: TextStyle(fontWeight: FontWeight.bold))),
              Text('Seguindo')
            ],
          )
        ],
      ),
    );
  }
}

class _UserSubhead extends StatelessWidget {

  EdgeInsets padding;
  ProfileStore store;
  _UserSubhead({required this.padding, required this.store});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Observer(builder: (_) {
            return Text(store.user?.displayName ?? 'Sem nome', style: TextStyle(fontWeight: FontWeight.bold));
          }),
          Observer(builder: (_) {
            return Text(store.bio ?? '');
          }),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.edit),
                label: Text('Editar perfil'),
                onPressed: () {
                  Modular.to.pushNamed('.${Constants.Routes.EDIT}');
                },
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.logout),
                label: Text('Logoff'),
                onPressed: () {
                  store.logoff()
                      .then((_) => Modular.to.popAndPushNamed(Constants.Routes.LOGIN));
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

class _UserGallery extends StatelessWidget {

  EdgeInsets padding;
  ProfileStore store;
  _UserGallery({required this.padding, required this.store});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: StreamBuilder(
        stream: store.posts,
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Deu erro');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingWidget(message: 'Aguarde...');
          }
          if (snapshot.hasData && snapshot.data!.docs.length > 0) {
            final posts = snapshot.data!.docs;
            store.setPostsCount(posts.length);
            // return Wrap(
            //   direction: Axis.horizontal,
            //   spacing: 1,
            //   runSpacing: 1,
            //   runAlignment: WrapAlignment.start,
            //
            //   children: posts.map((post) {
            //     final data = post.data() as Map<String, dynamic>;
            //     return Image.network(
            //       data['url'] as String,
            //       fit: BoxFit.cover,
            //       width: MediaQuery.of(ctx).size.width / 4,
            //     );
            //   }).toList(),
            // );
            return GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 1,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: posts.map((post) {
                final data = post.data() as Map<String, dynamic>;
                return Image.network(data['url'] as String, fit: BoxFit.cover);
              }).toList(),
            );
          }
          return Container();
        },
      ),
    );
  }
}
