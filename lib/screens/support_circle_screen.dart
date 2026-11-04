import 'package:flutter/material.dart';
import '../models/niamama_models.dart';
import '../services/location_service.dart';
import '../theme/nurture_bloom_theme.dart';

class SupportCircleScreen extends StatelessWidget {
  final NiamamaState state;
  final UserCoordinates userCoords;
  final void Function(String circleId) onToggleCircle;
  final VoidCallback onOpenSafeChat;
  final VoidCallback onOpenSpeedDial;
  final void Function(String guideId) onOpenCareGuide;
  final void Function(String message) onShowToast;

  const SupportCircleScreen({
    super.key,
    required this.state,
    required this.userCoords,
    required this.onToggleCircle,
    required this.onOpenSafeChat,
    required this.onOpenSpeedDial,
    required this.onOpenCareGuide,
    required this.onShowToast,
  });

  static const String _midwifeSarahImg =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAGrvAfjvdvvJ8xHMp_ASLJKDw5QxyYgA0cofp5lk2ewSf367RMIX_CN05lhHDxCc8-A35bkHOwzcS2aSHHTHW-PPV_i4KdguArT0QyGX3b73VfNcmFOLBvhL9rxX5aqDx2rdDk1hnfygt7or2ZGypSpW10E6G2tmBI7YN16d-CyqUELle2ngCeeIXkGRsppdpPYefdnnBxSqo2F4mVLvn9pBqsBjMiWBXhQPjUrR0';
  static const String _article1Img =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCB4K0IJ1Y9HvgzUYjDDfWgz9RnjgiLAXfrkubmqlrc1tWpi44oEmQAE7LOtZ_ifwW0j1IOzv5Ld4otVeRyDp416ddhD450cpM4ZyEOmboSAk0XCbZvVoYRWoqmGAaiVtIZPAQkQr4c4IodMLsmfRK7Yyf-vrVGsVK-BaAni7h6ShfIygoBLE0iRgkXCNCLZIWLjCGS_wpe6bXWnI_2pTwjXDONBrFGTmnWScns27E';
  static const String _article2Img =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBGhgxRtezUVjWnYh1NbFW6oBx2wCXa0p8thwOMVNOMCAonZOPUYfIzsFCvAN5lzJyfLl2FIl7d4njotKq8JzMfPCsjgESuF4UzaUKP8vT9_H0IR5Mz1slB2kV37Gf4wds380IwuoEFqmn6wYd5rAcK-KAWpBg3v6t74FtEl_9Cour3ucAUR-JdXz8uIKK8Tl6qbUqmvxkvdmPwh9rp8jxIjGwz63-zqOWilUj3zAw';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
      children: [
        // Welcoming Village Warm Banner
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: NurtureBloomColors.secondaryContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.surfaceContainerLowest
                      .withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.spa_rounded,
                      size: 16,
                      color: NurtureBloomColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Postpartum Haven • Day 28',
                      style: NurtureBloomTextStyles.labelSm.copyWith(
                        color: NurtureBloomColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your Support Circle',
                style: NurtureBloomTextStyles.headlineLgMobile.copyWith(
                  color: NurtureBloomColors.onSecondaryFixed,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "You don't have to navigate postpartum alone. Your midwives, fellow mothers, and care team are right here with you.",
                style: NurtureBloomTextStyles.bodyMd.copyWith(
                  color: NurtureBloomColors.onSecondaryContainer,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Priority Triage & Midwife Chat Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: NurtureBloomColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(24),
            boxShadow: NurtureBloomColors.ambientWarmShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            const CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(_midwifeSarahImg),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: NurtureBloomColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Registered Midwife Sarah',
                                      style: NurtureBloomTextStyles.headlineSm,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.verified_rounded,
                                    size: 18,
                                    color: NurtureBloomColors.primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Online now • Typical reply < 5 mins',
                                style: NurtureBloomTextStyles.labelSm.copyWith(
                                  color: NurtureBloomColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: NurtureBloomColors.primaryFixed,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Free • 24/7',
                      style: NurtureBloomTextStyles.labelSm.copyWith(
                        color: NurtureBloomColors.onPrimaryFixed,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Conversational Empathy Prompt
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '“Thinking about late-night feeding pain, healing changes, or baby sleep cues? No question is too small or silly. We are here to listen.”',
                      style: NurtureBloomTextStyles.bodyMd.copyWith(
                        color: NurtureBloomColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          size: 15,
                          color: NurtureBloomColors.outline,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Private, confidential & offline-capable clinical advice',
                          style: NurtureBloomTextStyles.labelSm.copyWith(
                            color: NurtureBloomColors.outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: onOpenSafeChat,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: NurtureBloomColors.primary,
                          foregroundColor: NurtureBloomColors.onPrimary,
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.chat_bubble_rounded, size: 18),
                        label: const Text('Start Safe Chat'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: TextButton.icon(
                        onPressed: () {
                          LocationService.dialNumber('0800720000');
                          onShowToast(
                            'Initiating encrypted midwife audio triage...',
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: NurtureBloomColors.secondaryFixed,
                          foregroundColor: NurtureBloomColors.onSecondaryFixed,
                          shape: const StadiumBorder(),
                        ),
                        icon: const Icon(Icons.phone_in_talk_rounded, size: 18),
                        label: const Text('Voice Call'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Mama's Trusted Circle (Emergency Speed-Dial & Immediate Contacts)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Immediate Loved Ones & Care',
                  style: NurtureBloomTextStyles.headlineSm,
                ),
                Text(
                  'One-tap speed-dial & GPS share when hands are occupied',
                  style: NurtureBloomTextStyles.bodySm,
                ),
              ],
            ),
            TextButton.icon(
              onPressed: onOpenSpeedDial,
              style: TextButton.styleFrom(
                backgroundColor: NurtureBloomColors.tertiaryFixed,
                foregroundColor: NurtureBloomColors.onTertiaryFixed,
                shape: const StadiumBorder(),
              ),
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
              label: const Text('Speed-Dial'),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ...state.contacts.map((contact) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: NurtureBloomColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              boxShadow: NurtureBloomColors.ambientWarmShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: NurtureBloomColors.primaryFixed,
                        backgroundImage: contact.avatarUrl != null
                            ? NetworkImage(contact.avatarUrl!)
                            : null,
                        child: contact.avatarUrl == null
                            ? Text(
                                contact.name.characters.first.toUpperCase(),
                                style: NurtureBloomTextStyles.headlineSm,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contact.name,
                              style: NurtureBloomTextStyles.labelLg,
                            ),
                            Text(
                              contact.subtitle,
                              style: NurtureBloomTextStyles.bodySm,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        LocationService.dialNumber(contact.phone);
                        onShowToast('Calling ${contact.name}...');
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: NurtureBloomColors.surfaceContainerLow,
                        foregroundColor: NurtureBloomColors.primary,
                      ),
                      icon: const Icon(Icons.call_rounded, size: 20),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      onPressed: () {
                        LocationService.sendEmergencyGpsSms(
                          phoneNumber: contact.phone,
                          coords: userCoords,
                          isUrgentSos: false,
                        );
                        onShowToast(
                          'Prepared SMS with live GPS location for ${contact.name}',
                        );
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: NurtureBloomColors.surfaceContainerLow,
                        foregroundColor: NurtureBloomColors.primary,
                      ),
                      icon: const Icon(Icons.sms_rounded, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 16),

        // Maternal Village Circles
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Maternal Village Circles',
                  style: NurtureBloomTextStyles.headlineSm,
                ),
                Text(
                  'Safe, moderated spaces to share raw solidarity',
                  style: NurtureBloomTextStyles.bodySm,
                ),
              ],
            ),
            Text(
              'Explore (8) >',
              style: NurtureBloomTextStyles.labelSm.copyWith(
                color: NurtureBloomColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        _buildCircleCard(
          id: 'newborn',
          icon: Icons.child_friendly_rounded,
          iconBg: NurtureBloomColors.primaryFixed,
          iconColor: NurtureBloomColors.onPrimaryFixed,
          title: 'Newborn 0–3 Months Mamas',
          subtitle: '1.4k active mothers • 87 sharing tonight',
          footer: '“How are you surviving the 3 AM cluster feed?”',
        ),
        const SizedBox(height: 10),
        _buildCircleCard(
          id: 'breastfeeding',
          icon: Icons.water_drop_rounded,
          iconBg: NurtureBloomColors.secondaryContainer,
          iconColor: NurtureBloomColors.onSecondaryContainer,
          title: 'Breastfeeding Sanctuary',
          subtitle: 'IBCLC Lactation Specialist moderated',
          footer: 'Gentle latch positioning & let-down comfort',
        ),
        const SizedBox(height: 10),
        _buildCircleCard(
          id: 'healing',
          icon: Icons.volunteer_activism_rounded,
          iconBg: NurtureBloomColors.tertiaryFixed,
          iconColor: NurtureBloomColors.onTertiaryFixed,
          title: 'Fourth Trimester Healing',
          subtitle: 'Pelvic recovery, mood, and gentle rest',
          footer: '“Zero shame night-waking confessions & hugs”',
        ),
        const SizedBox(height: 20),

        // Midwife-Crafted Wisdom
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Midwife-Crafted Wisdom',
              style: NurtureBloomTextStyles.headlineSm,
            ),
            Text('3 min reads', style: NurtureBloomTextStyles.labelSm),
          ],
        ),
        const SizedBox(height: 12),

        _buildArticleCard(
          imageUrl: _article1Img,
          fallbackIcon: Icons.baby_changing_station_rounded,
          tag: 'Growth Spurt',
          tagBg: NurtureBloomColors.secondaryFixed,
          tagColor: NurtureBloomColors.onSecondaryFixed,
          timeWindow: 'Day 21–42',
          title:
              'The 6-week growth spurt: Survival guide & cluster feeding rhythms',
          onTap: () => onOpenCareGuide('growth-spurt-6w'),
        ),
        const SizedBox(height: 10),
        _buildArticleCard(
          imageUrl: _article2Img,
          fallbackIcon: Icons.spa_rounded,
          tag: 'Emotional Well-being',
          tagBg: NurtureBloomColors.tertiaryFixed,
          tagColor: NurtureBloomColors.onTertiaryFixed,
          timeWindow: 'Mind • Body',
          title:
              'Postnatal baby blues vs. PPD: Knowing when you need an extra hand',
          onTap: () => onOpenCareGuide('baby-blues-vs-ppd'),
        ),
        const SizedBox(height: 18),

        // Reassurance Footnote
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NurtureBloomColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: NurtureBloomColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  size: 18,
                  color: NurtureBloomColors.onPrimaryFixed,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'You are doing wonderfully, Mama.',
                style: NurtureBloomTextStyles.labelMd,
              ),
              const SizedBox(height: 2),
              Text(
                'For acute medical emergencies, tap SOS above or call 1190 / 999 immediately.',
                style: NurtureBloomTextStyles.bodySm,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircleCard({
    required String id,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String footer,
  }) {
    final isJoined = state.joinedCircles[id] == true;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NurtureBloomColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        boxShadow: NurtureBloomColors.ambientWarmShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: iconColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: NurtureBloomTextStyles.headlineSm),
                          Text(subtitle, style: NurtureBloomTextStyles.bodySm),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => onToggleCircle(id),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isJoined
                        ? NurtureBloomColors.primaryFixed
                        : NurtureBloomColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isJoined ? 'Joined' : '+ Join',
                    style: NurtureBloomTextStyles.labelSm.copyWith(
                      color: isJoined
                          ? NurtureBloomColors.onPrimaryFixed
                          : NurtureBloomColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            footer,
            style: NurtureBloomTextStyles.bodySm.copyWith(
              color: NurtureBloomColors.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard({
    required String imageUrl,
    required IconData fallbackIcon,
    required String tag,
    required Color tagBg,
    required Color tagColor,
    required String timeWindow,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: NurtureBloomColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          boxShadow: NurtureBloomColors.ambientWarmShadow,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                imageUrl,
                width: 92,
                height: 92,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 92,
                  height: 92,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        NurtureBloomColors.primaryFixed,
                        NurtureBloomColors.secondaryContainer,
                      ],
                    ),
                  ),
                  child: Icon(
                    fallbackIcon,
                    size: 36,
                    color: NurtureBloomColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: tagBg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          tag,
                          style: NurtureBloomTextStyles.labelSm.copyWith(
                            color: tagColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(timeWindow, style: NurtureBloomTextStyles.bodySm),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: NurtureBloomTextStyles.labelLg,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Read guide',
                        style: NurtureBloomTextStyles.bodySm.copyWith(
                          color: NurtureBloomColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 15,
                        color: NurtureBloomColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
