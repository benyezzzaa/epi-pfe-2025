import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_client_controller.dart'; // 👈 adapte selon ton arborescence

class FiscalTextFieldWithCamera extends StatelessWidget {
  final AddClientController controller;
  final Function(String)? onSiretChanged; // Callback pour la validation en temps réel
  final bool isCheckingSiret;
  final bool siretExists;
  final String siretErrorMessage;

  const FiscalTextFieldWithCamera({
    super.key, 
    required this.controller,
    this.onSiretChanged,
    this.isCheckingSiret = false,
    this.siretExists = false,
    this.siretErrorMessage = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => TextFormField(
          controller: controller.fiscalNumberController,
          decoration: InputDecoration(
            labelText: 'SIRET *',
            suffixIcon: controller.isScanning.value || isCheckingSiret
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.camera_alt),
                    tooltip: 'Scanner un SIRET',
                    onPressed: controller.scanFiscalNumber,
                  ),
            // Ajouter une couleur de bordure selon l'état de validation
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: siretExists ? Colors.orange : Colors.grey,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: siretExists ? Colors.orange : Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: siretExists ? Colors.orange : Colors.blue,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: siretExists ? Colors.orange : Colors.red,
              ),
            ),
          ),
          keyboardType: TextInputType.number,
          maxLength: 14,
          onChanged: onSiretChanged, // Appeler le callback quand le SIRET change
                      validator: (value) {
              if (value == null || value.isEmpty) {
                return 'SIRET requis';
              }
              if (!RegExp(r'^\d{14}$').hasMatch(value)) {
                return 'Le SIRET doit contenir 14 chiffres';
              }
              if (siretExists) {
                return 'Ce SIRET existe déjà dans la base de données';
              }
              return null;
            },
            // Empêcher la soumission si le SIRET existe
            onFieldSubmitted: siretExists ? null : (value) {},
        )),
        // Afficher le message d'erreur si le SIRET existe
        if (siretExists && siretErrorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    siretErrorMessage,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
