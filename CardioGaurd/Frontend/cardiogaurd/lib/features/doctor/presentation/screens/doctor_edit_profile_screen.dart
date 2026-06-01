import 'dart:io';
import 'package:cardiogaurd/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_utils.dart';

class DoctorEditProfileScreen extends StatefulWidget {
  const DoctorEditProfileScreen({super.key});

  @override
  State<DoctorEditProfileScreen> createState() => _DoctorEditProfileScreenState();
}

class _DoctorEditProfileScreenState extends State<DoctorEditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _specialtyController;
  late TextEditingController _hospitalController;
  
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user;
    _nameController = TextEditingController(text: user?.displayName ?? "");
    _specialtyController = TextEditingController(text: user?.specialty ?? "");
    _hospitalController = TextEditingController(text: user?.hospital ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _hospitalController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Professional profile updated successfully')),
          );
          context.pop();
        } else if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Update failed'), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final user = state.user;
        
        return Scaffold(
          backgroundColor: MyColors.scaffoldBackground,
          appBar: AppBar(
            title: const Text("Edit Professional Info", style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
          ),
          body: state.status == AuthStatus.loading 
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildProfileHeader(user?.profileImageUrl, user?.email ?? ""),
                    const SizedBox(height: 32),
                    _buildInputs(),
                    const SizedBox(height: 32),
                    _buildSaveButton(),
                  ],
                ),
              ),
        );
      },
    );
  }

  Widget _buildProfileHeader(String? networkUrl, String email) {
    ImageProvider image;
    if (_selectedImage != null) {
      image = FileImage(_selectedImage!);
    } else {
      image = CardioImageUtils.getImageProvider(networkUrl, fallback: 'images/doctor_placeholder.png');
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: MyColors.primaryBlue, width: 3),
                  image: DecorationImage(image: image, fit: BoxFit.cover),
                ),
              ),
            ),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                backgroundColor: MyColors.primaryBlue,
                radius: 18,
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(email, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildInputs() {
    return Column(
      children: [
        _customTextField(label: "Full Name", controller: _nameController, icon: Icons.person_outline),
        const SizedBox(height: 16),
        _customTextField(label: "Specialty", controller: _specialtyController, icon: Icons.medical_services_outlined),
        const SizedBox(height: 16),
        _customTextField(label: "Hospital / Clinic", controller: _hospitalController, icon: Icons.local_hospital_outlined),
      ],
    );
  }

  Widget _customTextField({required String label, required TextEditingController controller, required IconData icon}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: MyColors.primaryBlue),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          context.read<AuthCubit>().updateProfile(
            name: _nameController.text,
            specialty: _specialtyController.text,
            hospital: _hospitalController.text,
            imageFile: _selectedImage,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
