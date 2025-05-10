import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class FormationDetailsPage extends StatefulWidget {
  final Map<String, dynamic> formation;

  const FormationDetailsPage({super.key, required this.formation});

  @override
  State<FormationDetailsPage> createState() => _FormationDetailsPageState();
}

class _FormationDetailsPageState extends State<FormationDetailsPage> {
  List<Map<String, dynamic>> _participants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadParticipants();
  }

  Future<void> _loadParticipants() async {
    setState(() => _isLoading = true);
    try {
      final participants = await DatabaseHelper.instance
          .getFormationParticipants(widget.formation['id']);
      setState(() {
        _participants = participants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors du chargement des participants'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.formation['titre'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Détails de la formation',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.description,
                      'Description',
                      widget.formation['description'],
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Période',
                      '${widget.formation['dateDebut']} - ${widget.formation['dateFin']}',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.location_on,
                      'Lieu',
                      widget.formation['lieu'],
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.people,
                      'Nombre de participants',
                      widget.formation['nombreParticipants'].toString(),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.attach_money,
                      'Prix',
                      '${widget.formation['prix']} €',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Participants', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_participants.isEmpty)
              const Center(child: Text('Aucun participant inscrit'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _participants.length,
                itemBuilder: (context, index) {
                  final participant = _participants[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(child: Text(participant['nom'][0])),
                      title: Text(
                        '${participant['nom']} ${participant['prenom']}',
                      ),
                      subtitle: Text(participant['email']),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () async {
                          try {
                            await DatabaseHelper.instance
                                .removeParticipantFromFormation(
                                  widget.formation['id'],
                                  participant['id'],
                                );
                            _loadParticipants();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Participant retiré avec succès',
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Erreur lors du retrait du participant',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }
}
