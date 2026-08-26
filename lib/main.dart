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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.kanitTextTheme(),
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
  
  // ใช้ Controller เพื่อให้เวลาแก้ ข้อมูลจะไปโผล่ในช่องกรอก
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String _petName = '';
  int _petAge = 0;
  double _petWeight = 0.0; // เพิ่มใหม่: ตัวแปรน้ำหนัก
  PetType _selectedType = PetType.dog;
  List<Pet> myPets = [];
  int? _editingIndex; // เพิ่มใหม่: เก็บตำแหน่งที่กำลังแก้ไข

  void _savePet() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        Pet newPet = Pet(
          name: _petName,
          type: _selectedType,
          age: _petAge,
          weight: _petWeight, // เพิ่มใหม่
          imagePath: 'assets/images/${_selectedType.name}.jpg',
        );

        if (_editingIndex != null) {
          myPets[_editingIndex!] = newPet; // แก้ไขตัวเดิม
          _editingIndex = null;
        } else {
          myPets.add(newPet); // เพิ่มตัวใหม่
        }

        // ล้างข้อมูลในฟอร์มหลังบันทึก
        _nameController.clear();
        _ageController.clear();
        _weightController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลเรียบร้อยแล้ว!')),
      );
    }
  }

  // เพิ่มใหม่: ฟังก์ชันลบ
  void _deletePet(int index) {
    setState(() {
      myPets.removeAt(index);
    });
  }

  // เพิ่มใหม่: ฟังก์ชันเตรียมแก้ไข
  void _prepareEdit(int index) {
    setState(() {
      _editingIndex = index;
      _nameController.text = myPets[index].name;
      _ageController.text = myPets[index].age.toString();
      _weightController.text = myPets[index].weight.toString();
      _selectedType = myPets[index].type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Pet Buddy อัปเกรด 🐾')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        _editingIndex == null ? 'เพิ่มสัตว์เลี้ยงใหม่' : 'แก้ไขข้อมูลสัตว์เลี้ยง',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'ชื่อสัตว์เลี้ยง'),
                        validator: (value) => value!.isEmpty ? 'กรุณากรอกชื่อ' : null,
                        onSaved: (value) => _petName = value!,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _ageController,
                        decoration: const InputDecoration(labelText: 'อายุ (ปี)'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _petAge = int.parse(value!),
                      ),
                      const SizedBox(height: 10),
                      // เพิ่มใหม่: ช่องกรอกน้ำหนัก
                      TextFormField(
                        controller: _weightController,
                        decoration: const InputDecoration(labelText: 'น้ำหนัก (กก.)'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _petWeight = double.parse(value!),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<PetType>(
                        initialValue: _selectedType,
                        decoration: const InputDecoration(labelText: 'ประเภท'),
                        items: PetType.values.map((type) {
                          return DropdownMenuItem(value: type, child: Text(type.name.toUpperCase()));
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedType = value!),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _savePet,
                        icon: Icon(_editingIndex == null ? Icons.save : Icons.edit),
                        label: Text(_editingIndex == null ? 'บันทึกข้อมูล' : 'ยืนยันการแก้ไข'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text('รายการสัตว์เลี้ยงของคุณ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                    // แก้ไข: แสดงน้ำหนักเพิ่มเข้าไป
                    subtitle: Text('ประเภท: ${myPets[index].type.name}\nอายุ: ${myPets[index].age} ปี | น้ำหนัก: ${myPets[index].weight} กก.'),
                    // เพิ่มใหม่: ปุ่มแก้ไขและลบ
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _prepareEdit(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deletePet(index),
                        ),
                      ],
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
}