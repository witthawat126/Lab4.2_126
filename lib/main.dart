import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pet_model.dart';

void main() {
  runApp(const MyPetApp());
}

class MyPetApp extends StatelessWidget {
  const MyPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.kanitTextTheme(), // ใช้ Google Font ทั่วแอป
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const PetFormPage(),
    );
  }
}

class PetFormPage extends StatefulWidget {
  const PetFormPage({super.key});

  @override
  State<PetFormPage> createState() => _PetFormPageState();
}

class _PetFormPageState extends State<PetFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _petName = '';
  int _petAge = 0;
  PetType _selectedType = PetType.dog;
  List<Pet> myPets = [];

  void _savePet() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        myPets.add(Pet(
          name: _petName,
          type: _selectedType,
          age: _petAge,
          imagePath: 'assets/images/${_selectedType.name}.jpg', // รูปจะเปลี่ยนตามประเภทที่เลือก
        ));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลสัตว์เลี้ยงแล้ว!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Pet Buddy 🐾')),
      body: SingleChildScrollView( // ป้องกัน Keyboard บังหน้าจอตามใบงานที่ 4
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ส่วนของฟอร์ม (Form)
            Form(
              key: _formKey,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'ชื่อสัตว์เลี้ยง'),
                        validator: (value) => value!.isEmpty ? 'กรุณากรอกชื่อ' : null,
                        onSaved: (value) => _petName = value!,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'อายุ (ปี)'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _petAge = int.parse(value!),
                      ),
                      const SizedBox(height: 10),
                      // Dropdown Menu ตามโจทย์
                      DropdownButtonFormField<PetType>(
                        initialValue: _selectedType,
                        decoration: const InputDecoration(labelText: 'ประเภทสัตว์เลี้ยง'),
                        items: PetType.values.map((type) {
                          return DropdownMenuItem(value: type, child: Text(type.name.toUpperCase()));
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedType = value!),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _savePet,
                        icon: const Icon(Icons.save),
                        label: const Text('บันทึกสัตว์เลี้ยง'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text('รายการสัตว์เลี้ยงของคุณ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            // ส่วนแสดงผลข้อมูลและภาพ (ListView)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myPets.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.asset(myPets[index].imagePath, width: 50, errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets)),
                    title: Text(myPets[index].name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('ประเภท: ${myPets[index].type.name} | อายุ: ${myPets[index].age} ปี'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}