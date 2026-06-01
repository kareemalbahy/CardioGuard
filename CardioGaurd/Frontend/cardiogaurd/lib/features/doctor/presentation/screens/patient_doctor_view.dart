import 'package:cardiogaurd/app/di/injection_container.dart';
import 'package:cardiogaurd/features/doctor/domain/entities/doctor_profile_entity.dart';
import 'package:cardiogaurd/features/doctor/presentation/cubit/patient_doctor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_utils.dart';
import '../widgets/doctor_contact_card.dart';

class PatientDoctorView extends StatelessWidget {
  const PatientDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PatientDoctorCubit>()..load(),
      child: const _PatientDoctorViewContent(),
    );
  }
}

class _PatientDoctorViewContent extends StatefulWidget {
  const _PatientDoctorViewContent();

  @override
  State<_PatientDoctorViewContent> createState() => _PatientDoctorViewContentState();
}

class _PatientDoctorViewContentState extends State<_PatientDoctorViewContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _removeDoctor(BuildContext context, DoctorProfileEntity doctor, {bool isPending = false}) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isPending ? "Cancel Request" : "Cancel Assignment"),
        content: Text(isPending 
          ? "Are you sure you want to cancel your request to ${doctor.name}?"
          : "Are you sure you want to remove ${doctor.name} from your medical care team?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text("Go Back")),
          TextButton(
            onPressed: () {
              context.read<PatientDoctorCubit>().cancelAssignment(doctor.id, isPending);
              Navigator.pop(dialogContext);
            },
            child: const Text("Confirm", style: TextStyle(color: MyColors.alertRed)),
          ),
        ],
      ),
    );
  }

  void _showDoctorProfile(BuildContext context, DoctorProfileEntity doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 60, 
              backgroundColor: MyColors.backgroundBlue,
              backgroundImage: CardioImageUtils.getImageProvider(doctor.imagePath, fallback: 'images/doctor_placeholder.png'),
            ),
            const SizedBox(height: 24),
            Text(doctor.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(doctor.specialty, style: const TextStyle(fontSize: 18, color: MyColors.primaryBlue, fontWeight: FontWeight.w600)),
            const SizedBox(height: 32),
            _profileInfoTile(Icons.local_hospital, "Hospital", doctor.hospital),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: MyColors.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text("Close Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: MyColors.backgroundBlue, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: MyColors.primaryBlue, size: 20)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Clinical Support",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<PatientDoctorCubit, PatientDoctorState>(
        builder: (context, state) {
          if (state is PatientDoctorLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PatientDoctorFailure) {
            return Center(child: Text(state.message));
          }
          if (state is! PatientDoctorLoaded) {
            return const SizedBox();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Medical\nCare Team.",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, height: 1.1),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Consult with your assigned specialists to manage your heart health effectively.",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                const SizedBox(height: 32),

                if (state.assignedDoctors.isEmpty && state.pendingDoctors.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(Icons.medical_services_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text("No specialists assigned yet.", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  )
                else ...[
                  ...state.assignedDoctors.map((doc) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DoctorContactCard(
                          doctor: doc,
                          onMessagePressed: () {
                            context.push('/chat', extra: {
                              'receiverId': doc.id,
                              'receiverName': doc.name,
                              'receiverImageUrl': doc.imagePath,
                            });
                          },
                          onViewProfile: () => _showDoctorProfile(context, doc),
                          onRemove: () => _removeDoctor(context, doc),
                        ),
                      )),

                  if (state.pendingDoctors.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      "Pending Approval",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1),
                    ),
                    const SizedBox(height: 12),
                    ...state.pendingDoctors.map((doc) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: MyColors.backgroundBlue,
                            backgroundImage: CardioImageUtils.getImageProvider(doc.imagePath, fallback: 'images/doctor_placeholder.png'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text("Waiting for acceptance...", style: TextStyle(fontSize: 12, color: Colors.orange[800])),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _removeDoctor(context, doc, isPending: true),
                            icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                          ),
                        ],
                      ),
                    )),
                  ],
                ],

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                
                const Text(
                  "Expand Your Care Team",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  onChanged: (query) => context.read<PatientDoctorCubit>().search(query),
                  decoration: InputDecoration(
                    hintText: "Search specialists to add...",
                    prefixIcon: const Icon(Icons.person_search_outlined, color: MyColors.primaryBlue),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                
                if (state.searchResults.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.searchResults.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final doc = state.searchResults[index];
                        final isAssigned = state.assignedDoctors.any((d) => d.id == doc.id);
                        final isPending = state.pendingDoctors.any((d) => d.id == doc.id);
                        
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: MyColors.backgroundBlue,
                            backgroundImage: CardioImageUtils.getImageProvider(doc.imagePath, fallback: 'images/doctor_placeholder.png'),
                          ),
                          title: Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(doc.specialty),
                          trailing: TextButton(
                            onPressed: (isAssigned || isPending) ? null : () => context.read<PatientDoctorCubit>().requestAssignment(doc.id),
                            child: Text(
                              isAssigned ? "Assigned" : (isPending ? "Pending" : "Assign"),
                              style: TextStyle(
                                color: isAssigned ? Colors.green : (isPending ? Colors.orange : MyColors.primaryBlue),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }
}
