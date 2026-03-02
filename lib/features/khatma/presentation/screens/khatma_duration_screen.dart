import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/khatma_provider.dart';
import '../../domain/models/khatma_model.dart';

class KhatmaDurationScreen extends StatefulWidget {
  final String startMode;
  final int? startJuz;

  const KhatmaDurationScreen({
    super.key,
    required this.startMode,
    this.startJuz,
  });

  @override
  State<KhatmaDurationScreen> createState() => _KhatmaDurationScreenState();
}

class _KhatmaDurationScreenState extends State<KhatmaDurationScreen> {
  int _durationDays = 30;
  String _amountType = 'جزء'; // جزء, حزب, ربع
  String _amountValue = '1 جزء'; // Options depend on the type

  final List<String> _amountTypes = ['جزء', 'ربع'];

  // Mock values based on the screenshots / User request
  final List<String> _juzValues = List.generate(10, (i) => '${i + 1} أجزاء')
    ..replaceRange(0, 2, ['جزء', 'جزءان']);
  final List<String> _rubValues = [
    'ربع',
    'ربعان',
    '3 أرباع',
    '4 أرباع',
    '5 أرباع',
    '6 أرباع',
    '7 أرباع',
  ];

  List<String> get _currentAmountValues {
    if (_amountType == 'جزء') return _juzValues;
    return _rubValues;
  }

  @override
  void initState() {
    super.initState();
    _amountValue = _currentAmountValues.first;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDarkMode ? Colors.white70 : const Color(0xFF6B6A66);
    final cardColor = isDarkMode ? AppColors.darkCardContent : Colors.white;
    final dropdownTextColor = isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'ختمة جديدة',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title text
              Text(
                'الرجاء تحديد المدة التي تريد أن تختم\nفيها أو كمية الورد اليومي الذي تود\nقراءته',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 50),

              // Duration Row
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    Text(
                      'مدة الختمة:',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Centered Number Field
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$_durationDays يوماً',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Plus / Minus Buttons
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(20), // Pill shape
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _durationDays++;
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.add,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: AppColors.primary,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_durationDays > 1) {
                                  setState(() {
                                    _durationDays--;
                                  });
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.remove,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Amount Row
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    Text(
                      'كمية\nالورد:',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Amount Type Dropdown (جزء, حزب, ربع)
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _amountType,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: isDarkMode ? Colors.white54 : Colors.grey,
                            ),
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: dropdownTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                            isExpanded: true,
                            items: _amountTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _amountType = val;
                                  _amountValue = _currentAmountValues.first;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Amount Value Dropdown
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _amountValue,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: isDarkMode ? Colors.white54 : Colors.grey,
                            ),
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: dropdownTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                            isExpanded: true,
                            items: _currentAmountValues.map((val) {
                              return DropdownMenuItem(
                                value: val,
                                child: Text(val),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _amountValue = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Continue Button
              ElevatedButton(
                onPressed: () async {
                  final provider = Provider.of<KhatmaProvider>(
                    context,
                    listen: false,
                  );
                  final newKhatma = KhatmaModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    startMode: widget.startMode,
                    startJuz: widget.startJuz ?? 1,
                    durationDays: _durationDays,
                    amountType: _amountType,
                    amountValue: _amountValue,
                    startDate: DateTime.now(),
                    currentJuz: widget.startJuz ?? 1,
                  );

                  await provider.startNewKhatma(newKhatma);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم إنشاء الختمة بنجاح!',
                          style: GoogleFonts.cairo(),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'الاستمرار',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
