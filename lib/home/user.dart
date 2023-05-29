class UserData {
   String firstname;
   String lastname;
   String email;
   int age;
   bool isStaff;

  UserData(  
      {required this.firstname,
      required this.lastname,
      required this.age,
      required this.email,
      required this.isStaff,});

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      firstname: map['first name'] ?? '',
      lastname: map['last name'] ?? '',
      email: map['email'] ?? '',
      age: map['age'] ?? 0,
      isStaff: map['isStaff']==null?false:map['isStaff'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first name'] = firstname;
    data['last name'] = lastname;
    data['email'] = email;
    data['age'] = age;
    return data;
  }
}
