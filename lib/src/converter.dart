part of springbok_db_mongo;

class MongoIdConverter extends Converter<Id, Mongo.ObjectId> {
  const MongoIdConverter();

  MongoId decode(ClassMirror variableType, Mongo.ObjectId value)
    => new MongoId.fromObjectId(value);

  Mongo.ObjectId encode(ClassMirror variableType, Id value)
    => (value is MongoId ? value : new MongoId.fromId(value))._mongoId;
}