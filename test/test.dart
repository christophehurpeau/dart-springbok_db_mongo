import 'package:unittest/unittest.dart';
import '../lib/springbok_db_mongo.dart';

class User extends Model {
  static final $ = new Model$<User>(User);
  
  Id id;
  String firstName;
  String lastName;
  int age;
}


main() {
  test('mapToInstance and instanceToMap',(){
    expect(User.$.variables.length, 4);
    var mongoId = new MongoId();
    User u = User.$.mapToInstance({
        'id': mongoId.toJson(),
        'firstName': 'John',
        'lastName': 'Doe',
        'age': 24,
    });
    expect(u.id, mongoId);
    expect(u.firstName, 'John');
    expect(u.lastName, 'Doe');
    expect(u.age, 24);
    
    expect(u.toMap(),{
      'id': mongoId.toJson(),
      'firstName': 'John',
      'lastName': 'Doe',
      'age': 24
    });
  });
}
