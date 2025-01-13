enum Issuetype {
  none,
  help,
  complain;

  factory Issuetype.fromMap(String type){
    Issuetype issueType = Issuetype.none;

    for (var val in Issuetype.values) {
      if(val.name == type) return issueType;
    }
    return issueType;
  }

}

enum IssueStatus {
  none,
  open,
  resolved;

  factory IssueStatus.fromMap(String type){
    IssueStatus issueType = IssueStatus.none;

    for (var val in IssueStatus.values) {
      if(val.name == type) return issueType;
    }
    return issueType;
  }

}