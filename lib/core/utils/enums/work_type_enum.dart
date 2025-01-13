enum WorkRole {
  teacher,
  assistantProfessor,
  professor,
  register,
  accountant,
  viceChancelor,
  staff;

  factory WorkRole.fromMap(String role){
    WorkRole workRole = WorkRole.teacher;

    for (var workRole in WorkRole.values) {
      if(workRole.name == role) return workRole;
    }
    return workRole;
  }

}

