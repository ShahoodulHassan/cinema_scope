import 'package:async/async.dart';
import 'package:cinema_scope/architecture/search_view_model.dart';

import '../models/person.dart';

class PersonViewModel extends ApiViewModel {
  Person? person;

  CancelableOperation? _operation;

  fetchPersonWithDetail(int id) {
    _operation = CancelableOperation<Person>.fromFuture(
      api.getPersonWithDetail(id),
    ).then((value) {
      person = value;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _operation?.cancel();
    super.dispose();
  }
}
