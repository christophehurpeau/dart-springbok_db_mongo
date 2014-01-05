part of springbok_db_mongo;

class MongoIdConverterRule extends ConverterRule<Id, Mongo.ObjectId> {
  const MongoIdConverterRule();

  MongoId decode(Converter converter, ClassMirror variableType, Mongo.ObjectId value)
    => new MongoId.fromObjectId(value);

  Mongo.ObjectId encode(Converter converter, ClassMirror variableType, Id value)
    => (value is MongoId ? value : new MongoId.fromId(value))._mongoId;
}