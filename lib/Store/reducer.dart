import '../Store/actions.dart';

int reducer(int previousState, dynamic action) {
  if (action == Actions.increment) {
    return previousState + 1;
  }

  return previousState;
}
