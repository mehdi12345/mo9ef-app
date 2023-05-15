import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moqefapp/database/database.dart';
import 'package:moqefapp/models/category.dart';
import 'package:moqefapp/models/machine_category.dart';
import 'package:moqefapp/providers/base_provider.dart';

class CategoryProvider extends BaseProvider {
  List<Category> _categories = [];
  List<Category> get categories => _categories;
  List<MachineCategory> _machineCategories = [];
  List<MachineCategory> get machineCategories => _machineCategories;

  init() async {
    setBusy(true);
    _machineCategories.clear();
    QuerySnapshot query = await Database.instance.machineCategory.get();
    _machineCategories = query.docs
        .map((element) =>
            MachineCategory.fromMap(element.data() as Map<String, dynamic>))
        .toList();
  }

  fetchCategories() async {
    _categories.clear();
    QuerySnapshot<Object?> query = await Database.instance.category.get();
    _categories = query.docs
        .map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }
}
