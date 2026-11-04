import 'package:flutter/material.dart';
import '../models/niamama_models.dart';
import '../theme/nurture_bloom_theme.dart';

class MidwifeSafeChatSheet extends StatefulWidget {
  final List<ChatMessage> messages;
  final void Function(List<String> topics, String messageText) onSendMessage;

  const MidwifeSafeChatSheet({
    super.key,
    required this.messages,
    required this.onSendMessage,
  });

  @override
  State<MidwifeSafeChatSheet> createState() => _MidwifeSafeChatSheetState();
}

class _MidwifeSafeChatSheetState extends State<MidwifeSafeChatSheet> {
  static const List<String> _topics = [
    'Feeding / Latch',
    'Sleep / Waking',
    'Physical Healing',
    'Mood & Tears',
  ];

  final Set<String> _selectedTopics = {};
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _textController.text.trim();
    if (text.isEmpty && _selectedTopics.isEmpty) return;
    widget.onSendMessage(_selectedTopics.toList(), text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: NurtureBloomColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: NurtureBloomColors.primaryFixed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.medical_services_rounded,
                        color: NurtureBloomColors.onPrimaryFixed,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Midwife Safe Chat',
                          style: NurtureBloomTextStyles.headlineSm,
                        ),
                        Text(
                          'Sarah is ready • Saved to offline vault',
                          style: NurtureBloomTextStyles.labelSm.copyWith(
                            color: NurtureBloomColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    backgroundColor: NurtureBloomColors.surfaceContainerLow,
                  ),
                  icon: const Icon(Icons.close_rounded, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Chat History Box
            Container(
              constraints: const BoxConstraints(maxHeight: 180),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: NurtureBloomColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.messages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, idx) {
                  final msg = widget.messages[idx];
                  return Align(
                    alignment: msg.isFromMama
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: msg.isFromMama
                            ? NurtureBloomColors.primary
                            : NurtureBloomColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        msg.text,
                        style: NurtureBloomTextStyles.bodySm.copyWith(
                          color: msg.isFromMama
                              ? NurtureBloomColors.onPrimary
                              : NurtureBloomColors.onSurface,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Topic Chips
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: NurtureBloomColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select what you'd like to talk through:",
                    style: NurtureBloomTextStyles.bodySm,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _topics.map((topic) {
                      final isSelected = _selectedTopics.contains(topic);
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedTopics.remove(topic);
                            } else {
                              _selectedTopics.add(topic);
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? NurtureBloomColors.primaryFixed
                                : NurtureBloomColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            topic,
                            style: NurtureBloomTextStyles.labelSm.copyWith(
                              color: isSelected
                                  ? NurtureBloomColors.onPrimaryFixed
                                  : NurtureBloomColors.onSurface,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _textController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Share what feels heavy right now...',
                filled: true,
                fillColor: NurtureBloomColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: NurtureBloomColors.primary,
                  foregroundColor: NurtureBloomColors.onPrimary,
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                icon: const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  'Connect with Sarah',
                  style: NurtureBloomTextStyles.labelLg.copyWith(
                    color: NurtureBloomColors.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
