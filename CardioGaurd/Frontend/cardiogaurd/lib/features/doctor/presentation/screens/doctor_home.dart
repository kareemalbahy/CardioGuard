import 'package:cardiogaurd/core/theme/app_colors.dart';
import 'package:cardiogaurd/core/utils/image_utils.dart';
import 'package:cardiogaurd/core/widgets/app_bar.dart';
import 'package:cardiogaurd/features/doctor/presentation/cubit/doctor_patients_cubit.dart';
import 'package:cardiogaurd/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cardiogaurd/core/widgets/global_drawer.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorPatientsCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user = authState.user;
        final profilePic = user?.profileImageUrl ?? 'images/doctor_placeholder.png';
        final name = user?.displayName ?? "Doctor";
        final email = user?.email ?? "";

        return Scaffold(
          backgroundColor: MyColors.scaffoldBackground,
          endDrawer: BuildDrawer(
            profilePictureUrl: profilePic,
            name: name,
            email: email,
          ),
          appBar: BuildAppBar(profilePictureUrl: profilePic),
          body: BlocBuilder<DoctorPatientsCubit, DoctorPatientsState>(
            builder: (context, state) {
              if (state.status == DoctorPatientsStatus.loading ||
                  state.status == DoctorPatientsStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == DoctorPatientsStatus.failure) {
                return Center(child: Text(state.message ?? 'Error'));
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (state.pendingAssignments.isNotEmpty) ...[
                    const Text(
                      "PENDING ASSIGNMENT REQUESTS",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...state.pendingAssignments.map((request) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue.withOpacity(0.1)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: MyColors.backgroundBlue,
                              child: Icon(Icons.person, color: MyColors.primaryBlue),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(request['patientName']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text("Requested: ${request['date']}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => context.read<DoctorPatientsCubit>().rejectAssignment(request['id']),
                                  icon: const Icon(Icons.close, color: MyColors.alertRed, size: 20),
                                ),
                                IconButton(
                                  onPressed: () => context.read<DoctorPatientsCubit>().acceptAssignment(request['id'], request['patientId']),
                                  icon: const Icon(Icons.check, color: Colors.green, size: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),
                  ],
                  const Text(
                    "YOUR PATIENTS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (state.patients.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text("No assigned patients yet.", style: TextStyle(color: Colors.grey)),
                      ),
                    )
                  else
                    ...state.patients.map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: CardioImageUtils.getImageProvider(p.profilePictureUrl),
                                backgroundColor: MyColors.backgroundBlue,
                              ),
                              title: Text(
                                p.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Last assessment: ${p.lastAssessmentDate} · '
                                '${p.lastRiskScore.toStringAsFixed(0)}% modeled risk',
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                context.push('/patient-details/${p.id}');
                              },
                            ),
                          ),
                        )),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
