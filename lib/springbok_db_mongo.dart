library springbok_db_mongo;

import 'dart:async';
import 'dart:mirrors';

import 'package:springbok_db/springbok_db.dart';
export 'package:springbok_db/springbok_db.dart';

import 'package:mongo_dart/mongo_dart.dart' as Mongo;
export 'package:mongo_dart/mongo_dart.dart' show MongoId;

part 'src/id.dart';
part 'src/cursor.dart';
part 'src/converter.dart';

springbokDbMongoInit() {
  Db.stringToStore['mongo'] = (Map config) => new MongoStore(config['uri']);
}

class MongoStore extends AbstractStore<MongoStoreInstance> {
  final Mongo.Db mongoDb;
  
  MongoStore(String uri): mongoDb = new Mongo.Db(uri);
  
  Future open() => 
      mongoDb.connection.connected ? new Future.value() : mongoDb.open();

  Mongo.DbCollection collection(String collectionName) => mongoDb.collection(collectionName);
  
  Future init(Db db) {
    return open();
  }

  MongoStoreInstance instance(Model$ model$)
    => new MongoStoreInstance(this, model$);
}

class MongoStoreInstance<T extends Model> extends AbstractStoreInstance<T> {
  static final Converters _converter = new Converters({
    reflectClass(Id): const MongoIdConverter(),
    reflectClass(Model): const ModelStoreConverter(),
    reflectClass(List): const ListStoreConverter(),
  });
  
  final MongoStore store;
  final Mongo.DbCollection collection;
  
  MongoStoreInstance(MongoStore store, Model$<T> model$):
    super(model$),
    this.store = store,
    collection = store.collection(model$.storeKey);
  
  Future open() => store.open();
  
  Converters get converter => _converter;

  Map instanceToStoreMapResult(Map result){
    result['_id'] = result.remove('id');
    return result;
  }
  
  T toModel(Map result) {
    if (result == null) return result;
    result['id'] = result.remove('_id');
    return model$.storeMapToInstance(result);
  }
  
  Future<MongoCursor<T>> cursor([criteria])
    => open().then((_) => new MongoCursor(this, collection.find(criteria)));
  Future<int> count([criteria])
    => open().then((_) => collection.count(criteria));
  Future<List> distinct(String field, [criteria])
    => open().then((_) => collection.distinct(field, criteria));

  Future<T> findOne([criteria, fields])
    => cursor(criteria).then((MongoCursor cursor){
        return cursor.next()
          .then((T model){
            cursor.close();
            return model;
          });
      });
  
  Future insert(Map values)
    => open().then((_) => collection.insert(values));
  Future insertAll(List<Map> values)
    => open().then((_) => collection.insertAll(values));

  Future update(criteria, Map values)
    => open().then((_) => collection.update(criteria, values, multiUpdate: true));
  Future updateOne(criteria, Map values) 
    => open().then((_) => collection.update(criteria, values, multiUpdate: false));
  
  Future save(Map values)
    => open().then((_) => collection.save(values));
  
  Future remove(criteria)
    => open().then((_) => collection.remove(criteria));
  Future removeOne(criteria)
    => open().then((_) => collection.remove(criteria)); //we cannot limit...
  
  Map idToCriteria(Id id) => {
    '_id': (id is MongoId ? id : new MongoId.fromHex(id.toString()))._mongoId
  };
}

