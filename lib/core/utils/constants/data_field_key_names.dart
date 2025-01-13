
class FirebaseStorageCollections{
  static String kUserProfile = 'userProfile';
  static String kPage = 'page';
  static String kChannel = 'channel';
  static String kPost = 'post';

}

class FirestoreUserPrv{
  static String kCollection = 'usersPrivate';
  static String kdocId = 'docId';
  static String kemail = 'email'; 
  static String kcountry = 'country'; 
  static String kaddress = 'address';
  static String kcontactNo = 'contactNo';
  static String kfullName = 'fullName';
  static String kjoinedAt = 'joinedAt';
  static String kimageUrl = 'imageUrl';
  static String kdescription = 'description';
}


class FirestoreUserPub{
  static String kCollection = 'usersPublic';
  static String kdocId = 'docId';
  static String kcountry = 'country'; 
  static String kaddress = 'address';
  static String kfullName = 'fullName';
  static String kimageUrl = 'imageUrl';
  static String kdescription = 'description';
}

class FirestoreEducationPrv{
  static String kCollection = 'educationsPrivate';
  static String kdocId = 'docId';
  static String kuserId = 'userId';
  static String kstudentId = 'studentId'; 
  static String kemail = 'email'; 
  static String kinstitutionDomain = 'institutionDomain';
  static String kpageName = 'pageName';
  static String kdegree = 'degree';
  static String ksubject = 'subject'; 
  static String moderators = 'moderators';
  static String adminIds = 'adminIds';
  static String kstartDate = 'startDate';
  static String kendDate = 'endDate';
  static String kapproveDetails = 'approveDetails';
  static String klastWriteAt = 'lastWriteAt';
}

class FirestoreEducationPub{
  static String kCollection = 'educationsPublic';
  static String kdocId = 'docId';
  static String kuserId = 'userId';
  static String kinstitutionDomain = 'institutionDomain';
  static String kpageName = 'pageName';
  static String kdegree = 'degree';
  static String ksubject = 'subject'; 
  static String kstartDate = 'startDate';
  static String kendDate = 'endDate';
  static String kinstitutionApproved = 'institutionApproved';
  static String klastWriteAt = 'lastWriteAt';
}



class FirestoreWorkRolesPrv{
  static String kCollection = 'workRolesPrivate';
  static String kdocId = 'docId';
  static String kuserId = 'userId';
  static String kworkId = 'workId';
  static String kdepartment = 'department';
  static String kworkRole = 'workRole'; 
  static String kemail = 'email'; 
  static String kcontactNo = 'contactNo';
  static String kinstitutionDomain = 'institutionDomain';
  static String kpageName = 'pageName'; 
  static String moderators = 'moderators';
  static String adminIds = 'adminIds';
  static String kstartDate = 'startDate';
  static String kendDate = 'endDate';
  static String kinstitutionApproved = 'institutionApproved';
  static String kendDateApproved = 'endDateApproved';
  static String klastWriteAt = 'lastWriteAt';
}

class FirestoreWorkRolesPub{
  static String kCollection = 'workRolesPublic';
  static String kdocId = 'docId';
  static String kuserId = 'userId';
  static String kdepartment = 'department';
  static String kworkRole = 'workRole'; 
  static String kinstitutionDomain = 'institutionDomain';
  static String kpageName = 'pageName'; 
  static String kstartDate = 'startDate';
  static String kendDate = 'endDate';
  static String kinstitutionApproved = 'institutionApproved';
  static String kendDateApproved = 'endDateApproved';
  static String klastWriteAt = 'lastWriteAt';
}

class FirestorePagePrv{
  static String kCollection = 'pagesPrivate';
  static String docId = 'docId';
  static String domain = 'domain';  
  static String createdAt = 'createdAt';
  static String approveDetail = 'approveDetail';
  static String approvedAt = 'approvedAt';   
  static String userId = 'userId' ;
  static String addedBy = 'addedBy' ;
  static String addedAt = 'addedAt' ;
}

class FirestorePagePublic {
  static const String kCollection = 'pagesPublic';
  static const String docId = 'docId';
  static const String pageName = 'pageName';
  static const String domain = 'domain';
  static const String pageType = 'pageType';
  static const String impression = 'impression';
  static const String description = 'description';
  static const String logoUrl = 'logoUrl';
  static const String public = 'public';
  static const String approved = 'approved';
  static const String deActivated = 'deActivated';
  static const String location = 'location';
  static const String channelList = 'channelList';
  static const String createdBy = 'createdBy';
  static const String adminIds = 'adminIds';
}



// class FirestoreInstituteAdmin{
//   static String docId = 'docId';
//   static String instituteId = 'instituteId' ;
//   static String instituteDomain = 'instituteDomain' ;
//   static String instituteName = 'instituteName' ;
//   static String userId = 'userId' ;
//   static String userEmail = 'userEmail' ;
//   static String userName = 'userName' ;
//   static String addedBy = 'addedBy' ;
//   static String isAddedByApp = 'isAddedByApp' ;
//   static String addedAt = 'addedAt';
// }

class FirestoreDormitoryPrv{
  static String kCollection = 'dormitoriesPrivate';
  static String docId = 'docId';
  static String imageId = 'imageId' ;
  static String name = 'name' ;
  static String instituteDomain = 'instituteDomain' ;
  static String roomRanges = 'roomRanges' ;
  static String instituteId = 'instituteId' ;
  static String moderators = 'moderators';
  static String adminIds = 'adminIds';
  static String createdBy = 'createdBy' ;
  static String createdAt = 'createdAt' ;
}

class FirestoreDormitoryPub{
  static String kCollection = 'dormitoriesPublic';
  static String docId = 'docId';
  static String imageId = 'imageId' ;
  static String name = 'name' ;
  static String instituteDomain = 'instituteDomain' ;
  static String roomRanges = 'roomRanges' ;
  static String instituteId = 'instituteId';
}

class FirestoreDegree{
  static String kCollection = 'degrees';
  static String docId = 'docId';
  static String degree = 'degree';
  static String fieldOfStudy = 'fieldOfStudy';
  static String kinstitutionDomain = 'institutionDomain';
}


class FirestoreChannel {
  static const String kCollection = 'channels';
  static const String docId = 'docId';
  static const String pageId = 'pageId';
  static const String channelName = 'channelName';
  static const String channelType = 'channelType';
  static const String impression = 'impression';
  static const String description = 'description';
  static const String logoUrl = 'logoUrl';
  static const String public = 'public';
  static const String followersCount = 'followersCount';
  static const String postCount = 'postCount';
  static const String createdBy = 'createdBy';
  static const String adminIds = 'adminIds';
  static const String createdAt = 'createdAt';
}

class FirestoreThreadCollection{
  static const String kCollection = 'threads';
  static const String docId = 'docId';
  static const String channelDocId = 'channelDocId';
  static const String pageDocId = 'pageDocId';
  static const String complaintStatusList = 'complaintStatusList';
  static const String createdBy = 'createdBy';
  static const String createdAt = 'createdAt';
  static const String lastUpdateAt = 'lastUpdateAt';
}

class FirestoreComplaintStatus{

}


class FirestoreComplaintsCollection {
  static const String kCollection = 'complaints';
  static const String statusList = 'statusList';
  static const String postDocId = 'postDocId';
  static const String complaintTag = 'complaintTag';
  static const String createdAt = 'createdAt';
  static const String lastEditAt = 'lastEditAt';
  static const String createdBy = 'createdBy';
}

class FirestorePostMetaData {
  static const String createdAt = 'createdAt';
  static const String channelDocId = 'channelDocId';
  static const String channelName = 'channelName';
  static const String channelType = 'channelType';
  static const String pageDocId = 'pageDocId';
  static const String pageName = 'pageName';
  static const String pageLogoUrl = 'pageLogoUrl';
}


class FirestorePosts {
  static const String kCollection = 'posts';
  static const String docId = 'docId';
  static const String postMetaData = 'postMetaData';
  static const String postType = 'postType';
  static const String createdBy = 'createdBy';
  static const String createdAt = 'createdAt';
  static const String lastEditAt = 'lastEditAt';
  static const String textContent = 'textContent';
  static const String imageContentUrls = 'imageContentUrls';
  static const String upVote = 'upVote';
  static const String impression = 'impression';
  static const String commentCount = 'commentCount';
}

class FirestoreNewsPosts {
  static const String kCollection = 'newsPosts'; 
  static const String docId = 'docId';
  static const String postMetaData = 'postMetaData';
  static const String postType = 'postType';
  static const String createdBy = 'createdBy';
  static const String createdAt = 'createdAt';
  static const String lastEditAt = 'lastEditAt';
  static const String textContent = 'textContent';
  static const String imageContentUrls = 'imageContentUrls';
  static const String upVote = 'upVote';
  static const String impression = 'impression';
  static const String commentCount = 'commentCount';
}


class FirestoreUpVoters{
  static const String kCollection = 'upVoters';
  static const String idList = 'idList';
}

class FirestoreDownVoters{
  static const String kCollection = 'downVoters';
  static const String idList = 'idList';
}

class FirestoreFollowers {
  static const String kCollection = 'followers';
  static const String idList = 'idList';
}

class FirestoreFollowingChannels {
  static const String kCollection = 'followingChannels';
  static const String idList = 'idList';
}

class FirestoreAdminOfChannels {
  static const String kCollection = 'adminOfChannels';
  static const String idList = 'idList';
}

class FirestoreAdmins {
  static const String kCollection = 'admins';
  static const String idList = 'idList';
}



/// kType is the type of document is present in the database at the moment. Means is the document is removed; added or modified.
/// Right now we only care about the types removed; added. If a document is added or modified; we simply set its type status as added.
const String kType = 'type';
const String kIsSynced = 'isSynced';


// static String kdormitoryId = 'dormitoryId';
// static String kdormitoryName = 'dormitoryName';
// static String kcreatedAt = 'createdAt';
// static String kupdatedAt = 'updatedAt';

// static String kcontent = 'content';
// static String kimageIdList = 'imageIdList';

// static String kFirestoreComplainCollection = 'complains';
// static String kcomplainType = 'complainType'; 


//static String kupdatedAt = 'updatedAt';


class FireStoreModerators{

  static String kCollection = 'moderators';
  static String role = 'role' ;
  static String userId = 'userId' ;
  static String addedBy = 'addedBy' ;
  static String addedAt = 'addedAt' ;
}