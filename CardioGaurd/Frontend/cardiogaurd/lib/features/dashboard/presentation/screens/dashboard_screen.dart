import 'package:cardiogaurd/core/theme/app_colors.dart';
import 'package:cardiogaurd/core/utils/assessment_utils.dart';
import 'package:cardiogaurd/features/history/domain/entities/history_entry_entity.dart';
import 'package:cardiogaurd/features/history/presentation/cubit/history_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
          if (historyData.isEmpty) {
            return const Center(child: Text('No history yet'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'HEART HEALTH INDEX',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Builder(
                  builder: (context) {
                    if (historyData.length < 2) {
                      return const Text.rich(
                        TextSpan(
                          text: 'Your risk is ',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: 'stable.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    final latest = historyData[0].score;
                    final previous = historyData[1].score;
                    final status = getAssessmentStatusInfo(latest, previous);
                    
                    return Text.rich(
                      TextSpan(
                        text: 'Your risk is ',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: '${status.text.toLowerCase()}.',
                            style: TextStyle(
                              color: status.color,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                _buildRiskScoreCard(historyData),
                const SizedBox(height: 20),
                _buildHistoryCard(historyData),
                const SizedBox(height: 20),
                _buildAIInsightCard(),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRiskScoreCard(List<HistoryEntryEntity> historyData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Risk Score Progression',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    '6 MONTHS',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                barGroups: [
                  for (int i = 0; i < historyData.length; i++)
                    _makeGroupData(i, historyData[historyData.length - 1 - i].score / 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.blue.withValues(alpha: 0.7),
          width: 18,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(List<HistoryEntryEntity> historyData) {
    final slice = historyData.take(4).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prediction History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          for (int i = 0; i < slice.length; i++)
            _historyItem(
              slice[i].date,
              '${slice[i].score}% Risk',
              getAssessmentStatusInfo(
                slice[i].score,
                i < historyData.length - 1 ? historyData[i + 1].score : null,
              ).text,
              getAssessmentStatusInfo(
                slice[i].score,
                i < historyData.length - 1 ? historyData[i + 1].score : null,
              ).color,
              onTap: () => context.push('/assessment-details', extra: slice[i]),
            ),
        ],
      ),
    );
  }

  Widget _historyItem(DateTime date, String risk, String status, Color color, {VoidCallback? onTap}) {
    final dateStr = DateFormat('MMM dd, yyyy').format(date);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(risk, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIInsightCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI CLINICAL INSIGHT',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Medication optimization suggested.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Adjusting your morning dose could further stabilize afternoon peaks.',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.push('/doctor-contact'),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.scaffoldBackground,
              foregroundColor: MyColors.primaryBlue,
              shape: const StadiumBorder(),
            ),
            child: const Text('Discuss with Doctor'),
          ),
        ],
      ),
    );
  }
}
