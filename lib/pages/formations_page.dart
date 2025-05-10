import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../widgets/bottom_navigation.dart';
import 'formation_details_page.dart';

class FormationsPage extends StatefulWidget {
  const FormationsPage({super.key});

  @override
  State<FormationsPage> createState() => _FormationsPageState();
}

class _FormationsPageState extends State<FormationsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateDebutController = TextEditingController();
  final _dateFinController = TextEditingController();
  final _lieuController = TextEditingController();
  final _nombreParticipantsController = TextEditingController();
  final _prixController = TextEditingController();
  List<Map<String, dynamic>> _formations = [];
  bool _isLoading = true;
  Map<String, dynamic>? _editingFormation;

  @override
  void initState() {
    super.initState();
    _loadFormations();
  }

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    _dateDebutController.dispose();
    _dateFinController.dispose();
    _lieuController.dispose();
    _nombreParticipantsController.dispose();
    _prixController.dispose();
    super.dispose();
  }

  Future<void> _loadFormations() async {
    setState(() => _isLoading = true);
    try {
      final formations = await DatabaseHelper.instance.getAllFormations();
      setState(() {
        _formations = formations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors du chargement des formations'),
          ),
        );
      }
    }
  }

  void _showFormDialog() {
    _editingFormation = null;
    _titreController.clear();
    _descriptionController.clear();
    _dateDebutController.clear();
    _dateFinController.clear();
    _lieuController.clear();
    _nombreParticipantsController.clear();
    _prixController.clear();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              _editingFormation == null
                  ? 'Nouvelle formation'
                  : 'Modifier la formation',
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _titreController,
                      decoration: const InputDecoration(labelText: 'Titre'),
                      validator:
                          (value) =>
                              value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      validator:
                          (value) =>
                              value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                    TextFormField(
                      controller: _dateDebutController,
                      decoration: const InputDecoration(
                        labelText: 'Date de début',
                      ),
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (date != null) {
                          _dateDebutController.text =
                              date.toIso8601String().split('T')[0];
                        }
                      },
                      validator:
                          (value) =>
                              value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                    TextFormField(
                      controller: _dateFinController,
                      decoration: const InputDecoration(
                        labelText: 'Date de fin',
                      ),
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (date != null) {
                          _dateFinController.text =
                              date.toIso8601String().split('T')[0];
                        }
                      },
                      validator:
                          (value) =>
                              value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                    TextFormField(
                      controller: _lieuController,
                      decoration: const InputDecoration(labelText: 'Lieu'),
                      validator:
                          (value) =>
                              value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                    TextFormField(
                      controller: _nombreParticipantsController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de participants',
                      ),
                      keyboardType: TextInputType.number,
                      validator:
                          (value) =>
                              value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                    TextFormField(
                      controller: _prixController,
                      decoration: const InputDecoration(labelText: 'Prix'),
                      keyboardType: TextInputType.number,
                      validator:
                          (value) =>
                              value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: _saveFormation,
                child: const Text('Enregistrer'),
              ),
            ],
          ),
    );
  }

  Future<void> _saveFormation() async {
    if (!_formKey.currentState!.validate()) return;

    final formation = {
      'titre': _titreController.text,
      'description': _descriptionController.text,
      'dateDebut': _dateDebutController.text,
      'dateFin': _dateFinController.text,
      'lieu': _lieuController.text,
      'nombreParticipants': int.parse(_nombreParticipantsController.text),
      'prix': double.parse(_prixController.text),
    };

    try {
      if (_editingFormation == null) {
        await DatabaseHelper.instance.insertFormation(formation);
      } else {
        formation['id'] = _editingFormation!['id'];
        await DatabaseHelper.instance.updateFormation(formation);
      }

      if (mounted) {
        Navigator.pop(context);
        _loadFormations();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _editingFormation == null
                  ? 'Formation créée avec succès'
                  : 'Formation mise à jour avec succès',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'enregistrement')),
        );
      }
    }
  }

  Future<void> _deleteFormation(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmer la suppression'),
            content: const Text(
              'Voulez-vous vraiment supprimer cette formation ?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Supprimer'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await DatabaseHelper.instance.deleteFormation(id);
        _loadFormations();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Formation supprimée avec succès')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de la suppression')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formations'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFormations,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _formations.isEmpty
              ? const Center(child: Text('Aucune formation trouvée'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _formations.length,
                itemBuilder: (context, index) {
                  final formation = _formations[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(
                        formation['titre'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(formation['description']),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${formation['dateDebut']} - ${formation['dateFin']}',
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16),
                              const SizedBox(width: 4),
                              Text(formation['lieu']),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _editingFormation = formation;
                              _titreController.text = formation['titre'];
                              _descriptionController.text =
                                  formation['description'];
                              _dateDebutController.text =
                                  formation['dateDebut'];
                              _dateFinController.text = formation['dateFin'];
                              _lieuController.text = formation['lieu'];
                              _nombreParticipantsController.text =
                                  formation['nombreParticipants'].toString();
                              _prixController.text =
                                  formation['prix'].toString();
                              _showFormDialog();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteFormation(formation['id']),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    FormationDetailsPage(formation: formation),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFormDialog,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 1,
        onTap: (index) {
          if (index != 1) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/participants');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/profile');
                break;
            }
          }
        },
      ),
    );
  }
}
