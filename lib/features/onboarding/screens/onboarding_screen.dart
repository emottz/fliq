import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/airplane_logo.dart';
import '../../../shared/widgets/primary_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  String _role = 'student';
  int _experienceYears = 0;
  DateTime? _targetDate;
  bool _saving = false;

  void _next() {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      _save();
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final profile = UserProfileModel(
      role: _role,
      experienceYears: _experienceYears,
      targetExamDate: _targetDate,
      level: ProficiencyLevel.beginner,
      totalXp: 0,
      streakDays: 0,
      categoryProgress: {},
    );
    await ref.read(userProfileProvider.notifier).saveProfile(profile);
    if (mounted) context.go('/subscription');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: AirplaneLogo()),
                  const SizedBox(height: 32),
                  _StepIndicator(current: _step, total: 3),
                  const SizedBox(height: 28),
                  Expanded(child: _buildStep()),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: _step < 2 ? 'Continue' : 'Get Started',
                    isLoading: _saving,
                    onPressed: _canProceed() ? _next : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _canProceed() {
    if (_step == 0) return _role.isNotEmpty;
    return true;
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _RoleStep(selected: _role, onSelect: (r) => setState(() => _role = r));
      case 1:
        return _ExperienceStep(
          value: _experienceYears,
          onChange: (v) => setState(() => _experienceYears = v),
        );
      case 2:
        return _DateStep(
          selected: _targetDate,
          onSelect: (d) => setState(() => _targetDate = d),
        );
      default:
        return const SizedBox();
    }
  }
}

class _StepIndicator extends StatelessWidget {
  final int current;
  final int total;
  const _StepIndicator({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final active = i <= current;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
            height: 4,
            decoration: BoxDecoration(
              color: active ? AppColors.primary : AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

class _RoleStep extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  const _RoleStep({required this.selected, required this.onSelect});

  static const _roles = [
    ('pilot', 'Pilot', Icons.flight),
    ('atc', 'Air Traffic Controller', Icons.radar),
    ('cabin_crew', 'Cabin Crew', Icons.airline_seat_recline_extra),
    ('student', 'Student', Icons.school),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('What is your role?', style: AppTextStyles.heading2),
        const SizedBox(height: 8),
        const Text('We\'ll personalize your learning path.', style: AppTextStyles.caption),
        const SizedBox(height: 24),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: _roles.map((r) {
              final isSelected = r.$1 == selected;
              return GestureDetector(
                onTap: () => onSelect(r.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.surfaceVariant : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(r.$3,
                          size: 36,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary),
                      const SizedBox(height: 10),
                      Text(
                        r.$2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ExperienceStep extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChange;
  const _ExperienceStep({required this.value, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Years of aviation experience?', style: AppTextStyles.heading2),
        const SizedBox(height: 8),
        const Text('This helps calibrate your starting level.', style: AppTextStyles.caption),
        const SizedBox(height: 48),
        Center(
          child: Text(
            '$value years',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 20,
          divisions: 20,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.surfaceVariant,
          onChanged: (v) => onChange(v.round()),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0', style: AppTextStyles.caption),
            Text('20+', style: AppTextStyles.caption),
          ],
        ),
      ],
    );
  }
}

class _DateStep extends StatelessWidget {
  final DateTime? selected;
  final ValueChanged<DateTime?> onSelect;
  const _DateStep({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('When is your target exam?', style: AppTextStyles.heading2),
        const SizedBox(height: 8),
        const Text('Optional — helps us track your deadline.', style: AppTextStyles.caption),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 90)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
              builder: (context, child) => Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(primary: AppColors.primary),
                ),
                child: child!,
              ),
            );
            onSelect(picked);
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected != null ? AppColors.primary : AppColors.divider,
                width: selected != null ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    color: selected != null ? AppColors.primary : AppColors.textSecondary),
                const SizedBox(width: 16),
                Text(
                  selected != null
                      ? '${selected!.day}/${selected!.month}/${selected!.year}'
                      : 'Select exam date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: selected != null ? AppColors.textPrimary : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (selected != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Text(
                  '${selected!.difference(DateTime.now()).inDays} days remaining',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        TextButton(
          onPressed: () => onSelect(null),
          child: const Text('Skip for now', style: TextStyle(color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}
