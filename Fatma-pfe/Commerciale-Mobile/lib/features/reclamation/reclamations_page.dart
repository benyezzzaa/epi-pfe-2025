import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe/features/reclamation/Controller/reclamation_controller.dart';
import 'package:intl/intl.dart';

class MesReclamationsPage extends StatefulWidget {
  const MesReclamationsPage({super.key});

  @override
  State<MesReclamationsPage> createState() => _MesReclamationsPageState();
}

class _MesReclamationsPageState extends State<MesReclamationsPage> {
  final controller = Get.put(ReclamationController());
  DateTime? selectedDate;
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Mes réclamations', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3F51B5),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: colorScheme.primary));
        }

        if (controller.mesReclamations.isEmpty) {
          return Center(child: Text("Aucune réclamation envoyée", style: TextStyle(color: colorScheme.onSurfaceVariant)));
        }

        // Filtrer les réclamations
        List filteredReclamations = controller.mesReclamations.where((rec) {
          bool dateMatch = true;
          bool statusMatch = true;

          // Filtre par date
          if (selectedDate != null) {
            final recDate = DateTime.tryParse(rec['created_at'] ?? '');
            if (recDate != null) {
              dateMatch = recDate.year == selectedDate!.year &&
                         recDate.month == selectedDate!.month &&
                         recDate.day == selectedDate!.day;
            }
          }

          // Filtre par statut
          if (selectedStatus != null && selectedStatus!.isNotEmpty) {
            statusMatch = (rec['status'] ?? '').toLowerCase() == selectedStatus!.toLowerCase();
          }

          return dateMatch && statusMatch;
        }).toList();

        return Column(
          children: [
            // Filtres
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Filtre par date
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.calendar_today, color: colorScheme.primary),
                          label: Text(
                            selectedDate != null 
                              ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                              : 'Filtrer par date',
                            style: TextStyle(color: colorScheme.onSurface),
                          ),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() {
                                selectedDate = date;
                              });
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: colorScheme.outlineVariant),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (selectedDate != null)
                        IconButton(
                          icon: Icon(Icons.clear, color: colorScheme.error),
                          onPressed: () {
                            setState(() {
                              selectedDate = null;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Filtre par statut
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedStatus,
                          decoration: InputDecoration(
                            labelText: 'Filtrer par statut',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('Tous les statuts')),
                            const DropdownMenuItem(value: 'ouverte', child: Text('Ouverte')),
                            const DropdownMenuItem(value: 'traitée', child: Text('Traitée')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (selectedStatus != null)
                        IconButton(
                          icon: Icon(Icons.clear, color: colorScheme.error),
                          onPressed: () {
                            setState(() {
                              selectedStatus = null;
                            });
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Liste des réclamations
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: filteredReclamations.length,
                itemBuilder: (context, index) {
                  final rec = filteredReclamations[index];
                  
                  // Safely access data, provide default values or handle null
                  final String sujet = rec['sujet'] ?? 'Sujet inconnu';
                  final String description = rec['description'] ?? 'Aucune description';
                  final String status = rec['status'] ?? 'Inconnu';
                  
                  // Formatage de la date avec fonction utilitaire
                  final String dateStr = ReclamationController.formatDateForDisplay(rec['created_at']);

                  Color statusColor = colorScheme.surfaceVariant;
                  Color onStatusColor = colorScheme.onSurfaceVariant;
                  switch(status.toLowerCase()) {
                    case 'ouverte':
                      statusColor = colorScheme.secondaryContainer;
                      onStatusColor = colorScheme.onSecondaryContainer;
                      break;
                    case 'traitée':
                      statusColor = colorScheme.tertiaryContainer;
                      onStatusColor = colorScheme.onTertiaryContainer;
                      break;
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: colorScheme.surface,
                    child: ListTile(
                      leading: Icon(Icons.report_problem, color: colorScheme.onSurfaceVariant),
                      title: Text(sujet, style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(description, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                            'Créée le $dateStr',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      trailing: Chip(
                         label: Text(status, style: TextStyle(color: onStatusColor, fontSize: 11, fontWeight: FontWeight.w600)),
                         backgroundColor: statusColor,
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
