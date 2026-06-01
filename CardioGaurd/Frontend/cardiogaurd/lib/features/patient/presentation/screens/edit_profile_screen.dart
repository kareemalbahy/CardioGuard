import 'dart:io';
import 'package:cardiogaurd/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_utils.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user;
    _nameController = TextEditingController(text: user?.displayName ?? "");
    _phoneController = TextEditingController(text: user?.phone ?? "");
    _dobController = TextEditingController(text: user?.dob ?? "");
    _genderController = TextEditingController(text: user?.gender ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _genderController.dispose();
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
            const SnackBar(content: Text('Profile updated successfully')),
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
            title: const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold)),
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
                    _buildProfileInputs(),
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
      image = CardioImageUtils.getImageProvider(networkUrl, fallback: 'images/patient_placeholder.png');
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
                  image: DecorationImage(
                    image: image,
                    fit: BoxFit.cover,
                  ),
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
        Text(
          _nameController.text,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          email,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildProfileInputs() {
    return Column(
      children: [
        _customTextField(label: "Full Name", controller: _nameController, icon: Icons.person_outline),
        const SizedBox(height: 16),
        _customTextField(label: "Phone Number", controller: _phoneController, icon: Icons.phone_android_outlined),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _customTextField(label: "Date of Birth", controller: _dobController, icon: Icons.cake_outlined, hint: "YYYY-MM-DD")),
            const SizedBox(width: 16),
            Expanded(child: _customTextField(label: "Gender", controller: _genderController, icon: Icons.wc_outlined)),
          ],
        ),
      ],
    );
  }

  Widget _customTextField({required String label, required TextEditingController controller, required IconData icon, String? hint}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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
            phone: _phoneController.text,
            dob: _dobController.text,
            gender: _genderController.text,
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