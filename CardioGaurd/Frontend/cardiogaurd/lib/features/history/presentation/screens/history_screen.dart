import 'package:cardiogaurd/core/theme/app_colors.dart';
import 'package:cardiogaurd/core/utils/assessment_utils.dart';
import 'package:cardiogaurd/features/history/presentation/cubit/history_cubit.dart';
import 'package:cardiogaurd/features/history/presentation/widgets/history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryCubit>().load();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffoldBackground,
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state.status == HistoryStatus.loading ||
              state.status == HistoryStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == HistoryStatus.failure) {
            return Center(child: Text(state.message ?? 'Error'));
          }

          final historyData = state.entries;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PREDICTION HISTORY',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.2,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your historical cardiac risk predictions based on past data and trends.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    for (int i = 0; i < historyData.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: BuildHistoryCard(
                          date: historyData[i].date,
                          risk: historyData[i].score,
                          status: getAssessmentStatusInfo(
                            historyData[i].score,
                            i < historyData.length - 1 ? historyData[i + 1].score : null,
                          ).text,
                          color: getAssessmentStatusInfo(
                            historyData[i].score,
                            i < historyData.length - 1 ? historyData[i + 1].score : null,
                          ).color,
                          onTap: () {
                            context.push('/assessment-details', extra: historyData[i]);
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
