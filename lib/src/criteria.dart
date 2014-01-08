part of springbok_db_mongo;

class MongoStoreCriteria extends StoreCriteria {
  final Model$ model$;
  
  Map _criteria = {};
  
  MongoStoreCriteria(this.model$);
  
  fieldEqualsTo(String field, value) {
    _criteria[field == 'id' ? '_id' : field] = value;
  }
  
  fieldInValues(String field, Iterable values) {
    _criteria[field == 'id' ? '_id' : field] = { r'$in': values };
  }
  
  toMap() {
    print('MongoStoreCriteria: ${model$.dataToStoreData(_criteria)}');
    return model$.dataToStoreData(_criteria);
  }
  toJson() => _criteria;
  
}