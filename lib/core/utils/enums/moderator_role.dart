enum ModeratorRole {
  none,
  admin,
  editor;

  factory ModeratorRole.fromMap(String role){
    ModeratorRole moderatorRole = ModeratorRole.none;

    for (var val in ModeratorRole.values) {
      if(val.name == role) return moderatorRole;
    }
    return moderatorRole;
  }

}