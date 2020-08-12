abstract class UsersEvent {}

class SearchEvent extends UsersEvent {
  String query;
  String myname;

  SearchEvent(this.query, this.myname);
}