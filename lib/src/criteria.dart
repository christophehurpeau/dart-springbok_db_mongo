part of springbok_db_mongo;

class MongoStoreCriteria extends StoreCriteria {
  final Model$ model$;
  
  Map criteria = {};
  
  MongoStoreCriteria(this.model$);
  
  fieldEqualsTo(String field, value) {
    criteria[field == 'id' ? '_id' : field] = value;
  }
  
  fieldInValues(String field, Iterable values) {
    criteria[field == 'id' ? '_id' : field] = { r'$in': values };
  }
  
  toMap() {
    print('MongoStoreCriteria: ${model$.dataToStoreData(criteria)}');
    return model$.dataToStoreData(criteria);
  }
  toJson() => criteria;
  
}