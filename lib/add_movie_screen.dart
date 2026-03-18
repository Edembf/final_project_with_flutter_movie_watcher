import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/movie.dart';

class AddMovieScreen extends StatefulWidget {
  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  // Clé globale pour valider le formulaire
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    // Très important : libérer les ressources
    _titleController.dispose();
    _genreController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  Future<void> _addMovie() async {
    // 1. Valider le formulaire via les validateurs
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final movie = Movie(
        // Utilisation de doc().id pour une ID Firestore propre au lieu du timestamp
        id: FirebaseFirestore.instance.collection('movies').doc().id,
        title: _titleController.text.trim(),
        genre: _genreController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        videoUrl: _videoUrlController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('movies')
          .doc(movie.id)
          .set(movie.toMap());

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout : $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un Film')),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView( // Évite les débordements de clavier
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_titleController, 'Titre'),
                    _buildTextField(_genreController, 'Genre'),
                    _buildTextField(_descriptionController, 'Description', maxLines: 3),
                    _buildTextField(_imageUrlController, 'URL de l\'image'),
                    _buildTextField(_videoUrlController, 'URL de la vidéo YouTube'),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addMovie,
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                        child: const Text('Ajouter le film'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Widget helper pour éviter la répétition de code
  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Ce champ est requis' : null,
      ),
    );
  }
}
