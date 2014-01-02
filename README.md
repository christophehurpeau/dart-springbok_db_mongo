[![Build Status](https://drone.io/github.com/christophehurpeau/dart-springbok_db_mongo/status.png)](https://drone.io/github.com/christophehurpeau/dart-springbok_db_mongo/latest)

springbok_db for MongoDB

Example:

```dart
class User extends Model {
  static final $ = new Model$<User>(User);
  
  Id id;
  String firstName;
  String lastName;
  int age;
}

main() {
  User.$.init().then((_) {
    User.$.findOne().then((User user) {
      print(user);
    });
  });
}

```
