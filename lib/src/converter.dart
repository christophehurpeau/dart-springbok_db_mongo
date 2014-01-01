part of springbok_db_mongo;

class MongoIdConverter extends Converter<MongoId, Mongo.ObjectId> {
  const MongoIdConverter();

  MongoId decode(ClassMirror variableType, Mongo.ObjectId value)
    => new MongoId.fromObjectId(value);

  Mongo.ObjectId encode(ClassMirror variableType, MongoId value)
    => value._mongoId;
}