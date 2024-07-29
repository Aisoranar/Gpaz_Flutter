import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileConductor extends StatefulWidget {
  @override
  _ProfileConductorState createState() => _ProfileConductorState();
}

class _ProfileConductorState extends State<ProfileConductor> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late User _user;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String _errorMessage = '';
  File? _imageFile;
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentReference userDocRef = _firestore.collection('users').doc(_user.uid);
      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>?;
          _nameController.text = _userData?['name'] ?? '';
          _plateController.text = _userData?['plate'] ?? '';
          _emailController.text = _userData?['email'] ?? '';
          _phoneController.text = _userData?['phone'] ?? '';
          _isLoading = false;
        });
      } else {
        // Documento no existe, se creará uno
        await userDocRef.set({
          'name': '',
          'plate': '',
          'profile_image': '',
          'email': '',  // Añadido para almacenar el correo
          'phone': '',  // Añadido para almacenar el número de teléfono
        });
        setState(() {
          _userData = {'name': '', 'plate': '', 'profile_image': '', 'email': '', 'phone': ''};
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los datos: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      _pickImage();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permiso para acceder a la cámara no concedido')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Crop the image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        maxWidth: 800,
        maxHeight: 800,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 80,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recortar Imagen',
            toolbarColor: Color.fromARGB(247, 0, 51, 122),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Recortar Imagen',
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.original,
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _imageFile = File(croppedFile.path);
        });
        _uploadImage();
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    try {
      String fileName = 'profile_images/${_user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = _storage.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(_imageFile!);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      DocumentReference userDocRef = _firestore.collection('users').doc(_user.uid);
      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        await userDocRef.update({'profile_image': downloadUrl});
        setState(() {
          _userData?['profile_image'] = downloadUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imagen actualizada exitosamente')),
        );
      } else {
        await userDocRef.set({
          'profile_image': downloadUrl,
        });
        setState(() {
          _userData?['profile_image'] = downloadUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imagen guardada exitosamente')),
        );
      }
    } catch (e) {
      print('Error al subir la imagen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir la imagen')),
      );
    }
  }

  Future<void> _updateUserData() async {
    if (_nameController.text.isEmpty || _plateController.text.isEmpty || _emailController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    try {
      await _firestore.collection('users').doc(_user.uid).update({
        'name': _nameController.text,
        'plate': _plateController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
      });
      setState(() {
        _userData?['name'] = _nameController.text;
        _userData?['plate'] = _plateController.text;
        _userData?['email'] = _emailController.text;
        _userData?['phone'] = _phoneController.text;
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datos actualizados exitosamente')),
      );
    } catch (e) {
      print('Error al actualizar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del Conductor', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(247, 0, 51, 122),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red, fontSize: 18)))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Color.fromARGB(247, 0, 51, 122), width: 4),
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircleAvatar(
                                        radius: 90,
                                        backgroundColor: Colors.grey[200],
                                        backgroundImage: _imageFile != null
                                            ? FileImage(_imageFile!)
                                            : (_userData?['profile_image'] != null
                                                ? NetworkImage(_userData!['profile_image']) as ImageProvider<Object>?
                                                : null),
                                        child: _imageFile == null && _userData?['profile_image'] == null
                                            ? Icon(Icons.person, size: 90, color: Colors.grey)
                                            : null,
                                      ),
                                    ),
                                  ),
                                  if (_isEditing) 
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: _requestPermissions,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          padding: EdgeInsets.all(8),
                                          child: Icon(Icons.edit, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 20),
                              _buildTextField(_nameController, 'Nombre', Icons.person),
                              SizedBox(height: 10),
                              _buildTextField(_plateController, 'Placa del Vehículo', Icons.directions_car),
                              SizedBox(height: 10),
                              _buildTextField(_emailController, 'Correo Electrónico', Icons.email),
                              SizedBox(height: 10),
                              _buildTextField(_phoneController, 'Número de Teléfono', Icons.phone),
                              SizedBox(height: 20),
                              _isEditing
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: _updateUserData,
                                          child: Text('Guardar Cambios'),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white, backgroundColor: Color.fromARGB(247, 0, 51, 122),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _isEditing = false;
                                            });
                                          },
                                          child: Text('Cancelar'),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white, backgroundColor: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isEditing = true;
                                        });
                                      },
                                      child: Text('Editar Perfil'),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white, backgroundColor: Color.fromARGB(247, 0, 51, 122),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon) {
    return TextField(
      controller: controller,
      enabled: _isEditing,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Color.fromARGB(247, 0, 51, 122)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color.fromARGB(247, 0, 51, 122), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color.fromARGB(247, 0, 51, 122), width: 2),
        ),
      ),
      style: TextStyle(color: Color.fromARGB(247, 0, 51, 122)),
    );
  }
}
