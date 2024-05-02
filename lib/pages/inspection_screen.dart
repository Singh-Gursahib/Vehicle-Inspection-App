import 'package:flutter/material.dart';
import 'package:my_mechanic_qld/vehicle.dart';

class InspectionScreen extends StatefulWidget {
  final Vehicle vehicle;

  const InspectionScreen({required this.vehicle});

  @override
  _InspectionScreenState createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Customer Name'),
              onSaved: (newValue) => widget.vehicle.customerName = newValue!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter customer name';
                }
                return null;
              },
            ),
            // Add more TextFormField widgets for other parameters
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Navigate to the next screen or perform any other action
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
