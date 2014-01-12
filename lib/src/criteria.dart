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
  
  or(Iterable<MongoStoreCriteria> listOfCriteria) {
    assert(criteria[r'$or'] == null);
    criteria[r'$or'] = listOfCriteria.map((c) => c.toMap());
  }
  
  toMap() {
    print('MongoStoreCriteria: ${model$.dataToStoreData(criteria)}');
    return model$.dataToStoreData(criteria);
  }
  toJson() => criteria;
  
}