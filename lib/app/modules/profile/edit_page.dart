import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaflutter/app/modules/profile/profile_store.dart';
import 'package:mobx/mobx.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);
  @override
  EditPageState createState() => EditPageState();
}
class EditPageState extends ModularState<EditPage, ProfileStore> {

  late final TextEditingController _nameController;
  late final TextEditingController _bioController;

  late final ImagePicker _picker;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: store.user?.displayName);
    _bioController = TextEditingController(text: store.bio);

    _picker = ImagePicker();

    reaction((_) => store.user, (_) {
      _nameController.text = store.user?.displayName ?? '';
    });

    reaction((_) => store.bio, (_) {
      _bioController.text = store.bio ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar perfil'),
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
            return TextButton(
              child: Text('Concluir', style: TextStyle(color: Theme.of(context).buttonColor, fontWeight: FontWeight.bold)),
              onPressed: () {
                store.updateProfile(
                    displayName: _nameController.text,
                    bio: _bioController.text
                ).then((_) {
                  Navigator.of(context).pop();
                });
              },
            );
          })
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 24),
          CircleAvatar(
            radius: 40,
            child: Observer(builder: (_) {
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
          TextButton(
            child: Text('Alterar foto de perfil'),
            onPressed: () {
              showModalBottomSheet(context: context, builder: (ctx) {
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        child: Row(
                          children: [
                            Icon(Icons.camera_alt_outlined),
                            SizedBox(width: 16),
                            Text('Usar a câmera')
                          ],
                        ),
                        onTap: () async {
                          final picturePath = await _picker.getImage(
                              source: ImageSource.camera,
                              imageQuality: 50,
                              maxWidth: 1920,
                              maxHeight: 1200
                          );
                          if (picturePath != null) {
                            store.updateProfilePicture(picturePath.path);
                          }
                          Navigator.of(ctx).pop();
                        },
                      ),
                      SizedBox(height: 16),
                      InkWell(
                        child: Row(
                          children: [
                            Icon(Icons.photo_library_outlined),
                            SizedBox(width: 16),
                            Text('Escolher da biblioteca')
                          ],
                        ),
                        onTap: () async {
                          final picturePath = await _picker.getImage(
                              source: ImageSource.gallery,
                              imageQuality: 50,
                              maxWidth: 1920,
                              maxHeight: 1200
                          );
                          if (picturePath != null) {
                            store.updateProfilePicture(picturePath.path);
                          }
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ],
                  ),
                );
              });
            },
          ),

          _EditField(
            label: 'Nome:',
            controller: _nameController,
            maxLengh: 50,
          ),
          _EditField(
            label: 'Bio:',
            controller: _bioController,
            maxLengh: 140,
          )

        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {

  String label;
  TextEditingController controller;
  int? maxLengh;

  _EditField({required this.label, required this.controller, this.maxLengh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 12),
          Flexible(
            child: Container(
              child: TextFormField(
                controller: controller,
                minLines: 1,
                maxLines: 10,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  isDense: true
                ),
                maxLength: maxLengh,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],

      ),
    );

  }

}
