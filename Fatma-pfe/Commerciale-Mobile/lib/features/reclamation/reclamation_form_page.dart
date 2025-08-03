import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe/features/reclamation/Controller/reclamation_controller.dart';


class ReclamationFormPage extends StatelessWidget {
  final controller = Get.find<ReclamationController>();

  ReclamationFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme; // Get color scheme

    return Scaffold(
      backgroundColor: colorScheme.background, // Use background color
      appBar: AppBar(
        title: const Text("Nouvelle réclamation", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3F51B5),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2, // Consistent elevation
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: colorScheme.primary)); // Use primary color
        }

        // Handle error state if available in controller
        // if (controller.errorMessage.isNotEmpty) {
        //   return Center(
        //     child: Text(
        //       controller.errorMessage.value,
        //       textAlign: TextAlign.center,
        //       style: TextStyle(color: colorScheme.error, fontSize: 16),
        //     ),
        //   );
        // }

        return Padding(
          padding: const EdgeInsets.all(16), // Consistent padding
          child: Form(
            key: controller.formKey,
            child: ListView(
              children: [
                // Titre pour la sélection du client
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Client concerné",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                // Zone de recherche de client avec clavier intelligent
                TextFormField(
                  controller: controller.clientSearchController,
                  decoration: InputDecoration(
                    labelText: 'Rechercher un client',
                    labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerLow,
                    hintText: 'Tapez le nom du client...',
                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    suffixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
                  ),
                  style: TextStyle(color: colorScheme.onSurface),
                  onChanged: (value) => controller.searchClient(value),
                  validator: (val) => controller.selectedClientId.value == null ? 'Client requis' : null,
                ),
                
                // Liste des clients filtrés
                if (controller.filteredClients.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(8),
                      color: colorScheme.surface,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.filteredClients.length,
                      itemBuilder: (context, index) {
                        final client = controller.filteredClients[index];
                        return ListTile(
                          title: Text(
                            client['nom'] ?? 'Client inconnu',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            client['adresse'] ?? 'Adresse non disponible',
                            style: TextStyle(color: colorScheme.onSurfaceVariant),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.primaryContainer,
                            child: Text(
                              (client['nom'] ?? 'C')[0].toUpperCase(),
                              style: TextStyle(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () {
                            controller.selectClient(client);
                            FocusScope.of(context).unfocus(); // Fermer le clavier
                          },
                        );
                      },
                    ),
                  ),
                
                // Client sélectionné affiché
                if (controller.selectedClientId.value != null)
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colorScheme.primary),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Client sélectionné: ${controller.selectedClientName.value}',
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.clear, color: colorScheme.primary),
                          onPressed: () => controller.clearSelectedClient(),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20), // Consistent spacing
                
                // Titre pour le sujet
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Sujet de la réclamation",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                TextFormField(
                  controller: controller.sujetController,
                  decoration: InputDecoration(
                    labelText: 'Sujet',
                     labelStyle: TextStyle(color: colorScheme.onSurfaceVariant), // Use onSurfaceVariant
                    border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8), // Consistent border radius
                       borderSide: BorderSide(color: colorScheme.outlineVariant), // Use outlineVariant
                    ),
                     focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8), // Consistent border radius
                       borderSide: BorderSide(color: colorScheme.primary, width: 2), // Use primary
                    ),
                     filled: true,
                     fillColor: colorScheme.surfaceContainerLow, // Use subtle surface color
                     hintStyle: TextStyle(color: colorScheme.onSurfaceVariant), // Use onSurfaceVariant
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15), // Adjusted padding
                  ),
                   style: TextStyle(color: colorScheme.onSurface), // Use onSurface
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Sujet requis' : null,
                ),
                const SizedBox(height: 20), // Consistent spacing

                // Titre pour la description
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Description détaillée",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                TextFormField(
                  controller: controller.descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Description',
                     labelStyle: TextStyle(color: colorScheme.onSurfaceVariant), // Use onSurfaceVariant
                    border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8), // Consistent border radius
                       borderSide: BorderSide(color: colorScheme.outlineVariant), // Use outlineVariant
                    ),
                     focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8), // Consistent border radius
                       borderSide: BorderSide(color: colorScheme.primary, width: 2), // Use primary
                    ),
                     filled: true,
                     fillColor: colorScheme.surfaceContainerLow, // Use subtle surface color
                     hintStyle: TextStyle(color: colorScheme.onSurfaceVariant), // Use onSurfaceVariant
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15), // Adjusted padding
                  ),
                   style: TextStyle(color: colorScheme.onSurface), // Use onSurface
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Description requise' : null,
                ),
                const SizedBox(height: 20), // Consistent spacing
                


                ElevatedButton.icon(
                  icon: Icon(Icons.send, color: colorScheme.onPrimary), // Use onPrimary
                  label: Text("Envoyer", style: TextStyle(fontSize: 16)), // Consistent font size
                  onPressed: controller.isLoading.value ? null : controller.submitReclamation, // Disable while loading
                   style: ElevatedButton.styleFrom(
                     backgroundColor: colorScheme.primary, // Use primary color
                     foregroundColor: colorScheme.onPrimary, // Use onPrimary
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Consistent border radius
                     padding: const EdgeInsets.symmetric(vertical: 16), // Consistent padding
                     elevation: 4, // Consistent elevation
                   ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
