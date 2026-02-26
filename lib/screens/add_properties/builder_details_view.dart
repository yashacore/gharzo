// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/common/common_widget/progress_bar.dart';
import 'package:gharzo_project/providers/builder_details_provider.dart';
import 'package:gharzo_project/screens/add_properties/upload_photo/upload_photo_view.dart';
import 'package:provider/provider.dart';

class BuilderDetailsView extends StatelessWidget {
  final String propertyId;

  const BuilderDetailsView({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BuilderDetailsProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC), // Modern off-white/blue tint
        appBar: CommonWidget.gradientAppBar(
          title: "Ownership & Legal",
          onPressed: () => Navigator.pop(context),
        ),
        body: Consumer<BuilderDetailsProvider>(
          builder: (context, p, _) {
            return Column(
              children: [
                PropertyProgressBar(
                  progress: 5 / 8, // 0.125
                  label: "Step 5 of 8 • Basic Details",
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        _buildSectionCard(
                          title: "Builder Info",
                          icon: Icons.business_center_rounded,
                          children: [
                            _customField(
                              "Builder Name",
                              p.nameCtrl,
                              Icons.person_outline,
                            ),
                            _customField(
                              "RERA ID",
                              p.reraCtrl,
                              Icons.verified_outlined,
                            ),
                            _customField(
                              "Project Name",
                              p.projectCtrl,
                              Icons.home_work_outlined,
                            ),
                          ],
                        ),

                        _buildSectionCard(
                          title: "Project Timeline",
                          icon: Icons.history_toggle_off_rounded,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _datePickerBox(
                                    "Possession",
                                    p.possessionDate,
                                    () => p.pickDate(context, true),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _datePickerBox(
                                    "Launch",
                                    p.launchDate,
                                    () => p.pickDate(context, false),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        _buildSectionCard(
                          title: "Specifications",
                          icon: Icons.format_list_bulleted_rounded,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _smallNumField(
                                    "Units",
                                    p.totalUnitsCtrl,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _smallNumField(
                                    "Towers",
                                    p.totalTowersCtrl,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _smallNumField(
                                    "Floors",
                                    p.totalFloorsCtrl,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        _buildSectionCard(
                          title: "Financing",
                          icon: Icons.account_balance_wallet_outlined,
                          children: [
                            _customField(
                              "Token Amount",
                              p.tokenAmountCtrl,
                              Icons.currency_rupee,
                              isNumber: true,
                            ),
                            const SizedBox(height: 10),
                            _loanSwitch(p),
                            if (p.loanAvailable) ...[
                              const SizedBox(height: 15),
                              _buildChipCloud(p.allBanks, p.approvedBanks, (b) {
                                p.approvedBanks.contains(b)
                                    ? p.approvedBanks.remove(b)
                                    : p.approvedBanks.add(b);
                                p.notifyListeners();
                              }),
                            ],
                          ],
                        ),

                        const SizedBox(height: 100), // Space for bottom button
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomSheet: _buildBottomButton(),
      ),
    );
  }

  // ================= ATTRACTIVE UI COMPONENTS =================

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF6366F1)),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _customField(
    String label,
    TextEditingController c,
    IconData icon, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _smallNumField(String label, TextEditingController c) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _datePickerBox(String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              date == null ? "Select" : "${date.day}/${date.month}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF6366F1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loanSwitch(dynamic p) {
    return Container(
      decoration: BoxDecoration(
        color: p.loanAvailable ? const Color(0xFFEEF2FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: const Text(
          "Loan Facility",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        value: p.loanAvailable,
        activeColor: const Color(0xFF6366F1),
        onChanged: (v) {
          p.loanAvailable = v;
          p.notifyListeners();
        },
      ),
    );
  }

  Widget _buildChipCloud(
    List<String> items,
    List<String> selected,
    Function(String) onToggle,
  ) {
    return Wrap(
      spacing: 8,
      children: items.map((item) {
        bool active = selected.contains(item);
        return ChoiceChip(
          label: Text(
            item,
            style: TextStyle(
              color: active ? Colors.white : Colors.black87,
              fontSize: 12,
            ),
          ),
          selected: active,
          selectedColor: const Color(0xFF6366F1),
          backgroundColor: const Color(0xFFF1F5F9),
          onSelected: (_) => onToggle(item),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
      }).toList(),
    );
  }

  Widget _buildBottomButton() {
    return Consumer<BuilderDetailsProvider>(
      builder: (context, p, _) => Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: PrimaryButton(
          title: "Next",
          onPressed: p.loading
              ? null
              : () async {
                  final ok = await p.submit(propertyId);
                  if (ok && context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UploadPhotoView(propertyId: propertyId),
                      ),
                    );
                  }
                },
        ),
      ),
    );
  }
}
