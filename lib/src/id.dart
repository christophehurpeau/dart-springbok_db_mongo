part of springbok_db_mongo;


class MongoId implements Id{
  final Mongo.ObjectId _mongoId;
  final String _hexString;
  
  factory MongoId([String string]) {
    if (string == null) {
      return new MongoId.fromObjectId(new Mongo.ObjectId());
    } else {
      return new MongoId.fromHex(string);
    }
  }
  
  MongoId.create(): this.fromObjectId(new Mongo.ObjectId());
  
  MongoId.fromHex(String string):
    _mongoId = Mongo.ObjectId.parse(string), _hexString = string;
  
  MongoId.fromObjectId(Mongo.ObjectId mongoId):
    _mongoId = mongoId, _hexString = mongoId.toHexString();
  
  String toString() => _hexString;
  String toJson() => _hexString;
  
  int get hashCode => _hexString.hashCode;
  
  bool operator==(Id other) => other.toString() == toString();
}