part of springbok_db_mongo;

class MongoCursor<T extends Model> extends StoreCursor<T> {
  final Mongo.Cursor cursor;
  
  Map get fields => cursor.fields;
  set fields(Map fields) => cursor.fields = fields;
  
  int get skip => cursor.skip;
  set skip(int skip) => cursor.skip = (skip == null ? 0 : skip);
  
  int get limit => cursor.limit;
  set limit(int limit) => cursor.limit = (limit == null ? 0 : limit);
  
  Map get sort => cursor.sort;
  set sort(Map sort) => cursor.sort = sort;
  
  MongoCursor(AbstractStoreInstance<T> store, this.cursor): super(store);
  
  Future<T> next() => cursor.nextObject().then(store.toModel);
  
  Future forEach(callback(T model))
    => cursor.forEach((Map result) => callback(store.toModel(result)));

  Future<List<T>> toList()
    => cursor.toList().then((List<Map> result)
        => result.map(store.toModel).toList(growable: false));
  
  Future close() => cursor.close();
}