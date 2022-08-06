
import 'package:gj_sms/add_contact/ContactModel.dart';
import 'package:gj_sms/group/model/SubGroupContact.dart';
import 'package:gj_sms/group/model/groupmodel.dart';
import 'package:gj_sms/group/model/sub_group.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {

  static const groupTableName = "groups";
  static const subGroupTableName = "subGroup";
  static const addContactTableName = "contactTable";
  static const subGroupContact = "subGroupContact";

  DatabaseHelper._();

  static final DatabaseHelper db = DatabaseHelper._();
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database> initDB() async {
    print("initDB executed");
    String path = join(await getDatabasesPath(), "gjSms.db");
    // await deleteDatabase(path);
    return await openDatabase(path,
        version: 6,
        onCreate: (Database db, int version) async {
          await db.execute(createGroup);
          await db.execute(createSubGroup);
          await db.execute(createContactTable);
          await db.execute(createSubgroupContacts);
        }
    );
  }

  //create tables
  static const createGroup = """ 
  CREATE TABLE IF NOT EXISTS $groupTableName (
  id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT NOT NULL)  
  """;
  static const createSubGroup = """
  CREATE TABLE IF NOT EXISTS $subGroupTableName (
  id INTEGER PRIMARY KEY AUTOINCREMENT,groupId INTEGER,
  title TEXT NOT NULL,
  FOREIGN KEY (groupId) REFERENCES $groupTableName(id))
  """;
  static const createContactTable = """
  CREATE TABLE IF NOT EXISTS $addContactTableName (
  id INTEGER PRIMARY KEY AUTOINCREMENT,phone INTEGER UNIQUE,
  name TEXT NOT NULL,course TEXT)
  """;
  static const createSubgroupContacts = """
  CREATE TABLE IF NOT EXISTS $subGroupContact (
  id INTEGER PRIMARY KEY AUTOINCREMENT,subId INTEGER,
  contactId INTEGER, FOREIGN KEY (subId) REFERENCES $subGroupTableName(id),
  FOREIGN KEY (contactId) REFERENCES $addContactTableName(id)
  )
  """;

  //curd operations for Group


  Future<void> insertGroup(Map<String, dynamic> values) async {
    final Database? db = await database;
    int d = await db!.insert(groupTableName, values);
    print(d);
  }
  Future<void> insertGroupFromImport(Map<String, dynamic> values) async {
    final Database? db = await database;
    int d = await db!.insert(groupTableName, values);
    print(d);
  }

  Future<List<GroupModel>> getGroups() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> datas = await db.rawQuery(
        'SELECT * FROM $groupTableName ');
    print("item size ${datas.length}");
    return datas.map((e) => GroupModel.fromMap(e)).toList();
  }

  Future<List<GroupModel>> getGroupWithId(int id) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> datas = await db.rawQuery(
        'SELECT * FROM $groupTableName WHERE id =?', [id]);
    print("item size ${datas.length}");
    if (datas.length == 0) {
      return [];
    }
    return datas.map((e) => GroupModel.fromMap(e)).toList();
  }

  Future<bool> checkGroupName(String title) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> datas = await db.rawQuery(
        'SELECT * FROM $groupTableName WHERE title =?', [title]);
    print("item size ${datas.length}");
    if (datas.length > 0) {
      return false;
    }
    return true;
  }

  Future<int> deleteGroup(int id) async {
    final Database db = await initDB();
    int f = await db.delete(groupTableName, where: 'id=?', whereArgs: [id]);
    await db.delete(subGroupTableName, where: "groupId=?", whereArgs: [id]);
    print(f);
    return f;
  }

  Future<int> updateGroup(GroupModel model) async {
    final Database db = await initDB();
    print(model.toJson());
    return await db.update(
        groupTableName, model.toJson(), where: "id = ?", whereArgs: [model.id]);
  }

//curd operations for subgroup
  Future<int> insertSubGroup(SubGroup model) async {
    Map<String, dynamic> values = {
      'groupId': model.groupId,
      'title': model.title,

    };
    final Database db = await initDB();
    int inserted = await db.insert(subGroupTableName, values);
    return inserted;
  }

  Future<String> getSubGroupNameWithId(int id) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> datas = await db.rawQuery(
        'SELECT * FROM $subGroupTableName WHERE id =?', [id]);

    print("item size ${datas.length}");
    if (datas.length > 0) {
      return "";
    }
    return datas.first['title'];
  }
  Future<List<SubGroup>> getSubGroupListWithId(int id) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> datas = await db.rawQuery(
        'SELECT * FROM $subGroupTableName WHERE groupId =?', [id]);


    return  datas.map((e) => SubGroup.fromMap(e)).toList();
  }

  Future<bool> checkSubGroupName(String title) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> datas = await db.rawQuery(
        'SELECT * FROM $subGroupTableName WHERE title =?', [title]);
    print("item size ${datas.length}");
    if (datas.length > 0) {
      return false;
    }
    return true;
  }

  Future<List<SubGroup>> getSubGroup() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> data = await db.rawQuery(
        "SELECT $subGroupTableName.id,$subGroupTableName.title,$subGroupTableName.groupId,$groupTableName.title AS groupTitle FROM $subGroupTableName INNER JOIN $groupTableName ON $subGroupTableName.groupId = $groupTableName.id");
    print(
        "SELECT $subGroupTableName.id,$subGroupTableName.title,$subGroupTableName.groupId,$groupTableName.title AS groupTitle FROM $subGroupTableName INNER JOIN $groupTableName ON $subGroupTableName.groupId = $groupTableName.id");
    print("list length in table $data");
    return data.map((e) => SubGroup.fromMap(e)).toList();
  }


  Future<int> updateSubGroups(SubGroup model) async {
    Map<String, dynamic> values = {
      'groupId': model.groupId,
      'title': model.title,
      'id': model.id
    };
    print("model from database ${model.toMap()}");
    final Database db = await initDB();
    int f = await db.update(
        subGroupTableName, values, where: "id =?", whereArgs: [model.id]);
    print(f);
    return f;
  }

  Future<int> deleteSubGroups(int id) async {
    final Database db = await initDB();
    int f = await db.delete(subGroupTableName, where: 'id=?', whereArgs: [id]);
    print(f);
    return f;
  }

//curd operations of contacts
  Future<bool> insertContacts(ContactModel model) async {
    print(model.toMap());
    final Database db = await initDB();
    int inserted = await db.insert(addContactTableName, model.toMap());
    if (inserted == -1) {
      return false;
    }

    return true;
  }
  Future<List<ContactModel>> getContactsWithId(int s) async{
    final Database db = await initDB();
    final List<Map<String, dynamic>> data = await db.rawQuery(
        "SELECT * FROM $addContactTableName WHERE id =?",
        [s]
    );
    print("data : $data}");
    return data.map((e) => ContactModel.fromMap(e)).toList();
  }
  Future<List<ContactModel>> getContactsWithSearch(String s) async{
    final Database db = await initDB();
    final List<Map<String, dynamic>> data = await db.rawQuery(
      "SELECT * FROM $addContactTableName WHERE (name LIKE ?) OR (phone LIKE ?)",
        [s+"%"]
    );
    print("data : $data");
    return data.map((e) => ContactModel.fromMap(e)).toList();
  }

  Future<List<ContactModel>> getAllContacts() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> data = await db.rawQuery(
        "SELECT * FROM $addContactTableName");
    print( "data : $data");
    return data.map((e) => ContactModel.fromMap(e)).toList();
  }
  Future<List<ContactModel>> getContactsWithIdS(int id) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> data = await db.rawQuery(
        "SELECT * FROM $addContactTableName WHERE id =?",[id]);

    print( "data : $data");
    return data.map((e) => ContactModel.fromMap(e)).toList();
  }

  Future<bool> checkContact(int phone) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> data = await db.rawQuery(
        "SELECT * FROM $addContactTableName WHERE phone=?", [phone]);
    if (data.isEmpty) {
      return true;
    }
    return false;
  }

  Future<bool> updateContacts(ContactModel model) async {
    final Database db = await initDB();
    int update = await db.update(
        addContactTableName, model.toMap(), where: "id=?",
        whereArgs: [model.id]);
    return true;
  }

  Future<bool> deleteContacts(int id) async {
    final Database db = await initDB();
    int delete = await db.delete(
        addContactTableName, where: "id=?", whereArgs: [id]);
    return true;
  }


  //curd operations for subgroup contacts
  Future<bool> insertGrpContacts(int subId, int conId) async {
    Map<String, dynamic> values = {
      'subId': subId,
      'contactId': conId,

    };

    final Database db = await initDB();
    int insert = await db.insert(subGroupContact, values);
    print("values $values inserted $insert");
    return true;
  }

  Future<bool> checkExists(int subId, int conId) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> data = await db.rawQuery(
        "SELECT * FROM $subGroupContact WHERE subId =? AND contactId =?",
        [subId, conId]);
    if (data.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
  Future<List<SubGrpContacts>> getAllSubGrpContacts() async{
    final Database db = await initDB();
    final List<Map<String, dynamic>> data = await db.rawQuery(
        "SELECT * FROM $subGroupContact ");
    print(data);
    return data.map((e) => SubGrpContacts.fromMap(e)).toList();
  }
  Future<List<SubGrpContacts>> selectGrpContacts(int subId) async{
    final Database db = await initDB();
    final List<Map<String, dynamic>> data = await db.rawQuery(
        "SELECT * FROM $subGroupContact WHERE subId =?",
        [subId]);
    print(data);
    return data.map((e) => SubGrpContacts.fromMap(e)).toList();
  }

  Future<bool> updateGrpContacts(SubGrpContacts contacts) async {
    final Database db = await initDB();
    int update = await db.update(subGroupContact, contacts.toMap(),where: "id =?",whereArgs: [contacts.id]);
    return true;
  }
  Future<bool> deleteGrpContacts(int subId,int conId) async{
    final Database db = await initDB();
    int delete = await db.delete(subGroupContact,where: "subId =? AND contactId=?",whereArgs: [subId,conId]);
    print("$delete deleted");
    return true;
  }
}
