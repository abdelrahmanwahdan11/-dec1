import 'membership_perk.dart';

class MembershipStatus {
  final String tier;
  final int points;
  final int nextTierAt;
  final List<MembershipPerk> perks;

  const MembershipStatus({
    required this.tier,
    required this.points,
    required this.nextTierAt,
    required this.perks,
  });

  MembershipStatus copyWith({
    String? tier,
    int? points,
    int? nextTierAt,
    List<MembershipPerk>? perks,
  }) {
    return MembershipStatus(
      tier: tier ?? this.tier,
      points: points ?? this.points,
      nextTierAt: nextTierAt ?? this.nextTierAt,
      perks: perks ?? this.perks,
    );
  }
}
