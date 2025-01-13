enum ComplainType {
  harassment,
  room,
  relatable;


  factory ComplainType.fromMap(String complain){
    ComplainType complainRet = ComplainType.harassment;

    for (var complainVal in ComplainType.values) {
      if(complainVal.name == complain) return complainVal;
    }
    return complainRet;
  }
}
