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
part 'src/criteria.dart';

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
  static final Map _converterRules = {
    reflectClass(Id): const MongoIdConverterRule(),
    reflectClass(IdString): const MongoIdConverterRule(),
    reflectClass(MongoId): const MongoIdConverterRule(),
    reflectClass(Model): const ModelToMapStoreRule(),
  };
  
  final MongoStore store;
  final Mongo.DbCollection collection;
  
  MongoStoreInstance(MongoStore store, Model$<T> model$):
    super(model$),
    this.store = store,
    collection = store.collection(model$.storeKey);
  
  Future open() => store.open();
  
  Map get converterRules => _converterRules;

  StoreCriteria newCriteria() => new MongoStoreCriteria(model$);

  StoreCriteria idToCriteria(Id id) => newCriteria()..fieldEqualsTo('id',
                        id is MongoId ? id : new MongoId.fromHex(id.toString()));
  StoreCriteria idsToCriteria(Iterable<Id> ids) => newCriteria()
      ..fieldInValues('id', ids.map((id) => id is MongoId ? id : new MongoId.fromHex(id.toString()))
          .toList(growable: false));
  
  Map instanceToStoreMapResult(Map result){
    var id = result.remove('id');
    if (id != null) {
      result['_id'] = id;
    }
    return result;
  }
  
  T toModel(Map result) {
    if (result == null) return result;
    result['id'] = result.remove('_id');
    return model$.storeMapToInstance(result);
  }
  
  Future<MongoCursor<T>> cursor([MongoStoreCriteria criteria])
    => open().then((_){
      print('MognoStoreInstance: new cursor, criteria = ${criteria.toMap()}');
      return new MongoCursor(this, collection.find(criteria.toMap()));
    });
  Future<int> count([MongoStoreCriteria criteria])
    => open().then((_) => collection.count(criteria == null ? null : criteria.toMap()));
  Future<List> distinct(String field, [MongoStoreCriteria criteria])
    => open().then((_) => collection.distinct(field, criteria == null ? null : criteria.toMap()));

  Future<T> findOne([MongoStoreCriteria criteria, fields])
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

  Future update(MongoStoreCriteria criteria, Map values)
    => open().then((_) => collection.update(criteria == null ? null : criteria.toMap(), values, multiUpdate: true));
  Future updateOne(MongoStoreCriteria criteria, Map values) 
    => open().then((_) => collection.update(criteria == null ? null : criteria.toMap(), values, multiUpdate: false));
  
  Future save(Map values)
    => open().then((_) => collection.save(values));
  
  Future remove(MongoStoreCriteria criteria)
    => open().then((_) => collection.remove(criteria == null ? null : criteria.toMap()));
  Future removeOne(MongoStoreCriteria criteria)
    => open().then((_) => collection.remove(criteria == null ? null : criteria.toMap())); //we cannot limit...
  
}

