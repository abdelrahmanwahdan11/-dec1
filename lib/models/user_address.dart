import 'dart:convert';

class UserAddress {
  final String id;
  final String label;
  final String name;
  final String phone;
  final String city;
  final String street;
  final bool isDefault;

  const UserAddress({
    required this.id,
    required this.label,
    required this.name,
    required this.phone,
    required this.city,
    required this.street,
    this.isDefault = false,
  });

  UserAddress copyWith({
    String? id,
    String? label,
    String? name,
    String? phone,
    String? city,
    String? street,
    bool? isDefault,
  }) {
    return UserAddress(
      id: id ?? this.id,
      label: label ?? this.label,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      street: street ?? this.street,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'name': name,
      'phone': phone,
      'city': city,
      'street': street,
      'isDefault': isDefault,
    };
  }

  factory UserAddress.fromMap(Map<String, dynamic> map) {
    return UserAddress(
      id: map['id'] as String,
      label: map['label'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      city: map['city'] as String,
      street: map['street'] as String,
      isDefault: map['isDefault'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAddress.fromJson(String source) =>
      UserAddress.fromMap(json.decode(source) as Map<String, dynamic>);
}
