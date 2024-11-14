import 'package:employees_catalogue/data/component.dart';
import 'package:employees_catalogue/data/person.dart';
import 'package:employees_catalogue/person_details_page.dart';
import 'package:employees_catalogue/widget_keys.dart';
import 'package:flutter/material.dart';
import 'package:employees_catalogue/data/extensions.dart';

class PeopleListPage extends StatefulWidget {
  final String title;

  const PeopleListPage({Key? key, required this.title}) : super(key: key);

  @override
  _PeopleListPageState createState() => _PeopleListPageState();
}

class _PeopleListPageState extends State<PeopleListPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Responsibility? _selectedResponsibility;
  List<Person> _people = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _updatePeopleList();
  }

  void _onSearchChanged() {
    _updatePeopleList();
  }

  void _updatePeopleList() {
    setState(() {
      _people = Component.instance.api.searchPeople(
        query: _searchController.text.toLowerCase(),
        responsibility: _selectedResponsibility,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: LeadingWidget(
          onClick: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                _updatePeopleList();
              }
            });
          },
        ),
        actions: [
          PopupMenuButton<Responsibility>(
            key: WidgetKey.filter,
            onSelected: (Responsibility responsibility) {
              setState(() {
                _selectedResponsibility = responsibility;
                _updatePeopleList();
              });
            },
            itemBuilder: (BuildContext context) {
              return Responsibility.values.map((Responsibility responsibility) {
                return PopupMenuItem<Responsibility>(
                  value: responsibility,
                  child: Text(responsibility.toNameString()),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                key: WidgetKey.search,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              key: WidgetKey.listOfPeople,
              itemCount: _people.length,
              itemBuilder: (context, index) {
                return PersonItemWidget(
                  person: _people[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonDetailsPage(
                          personId: _people[index].id,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class LeadingWidget extends StatelessWidget {
  final VoidCallback onClick;

  const LeadingWidget({Key? key, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: onClick,
    );
  }
}

class PersonItemWidget extends StatelessWidget {
  final Person person;
  final VoidCallback onTap;

  const PersonItemWidget({
    Key? key,
    required this.person,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(person.fullName),
      subtitle: Text(person.responsibility.toNameString()),
      onTap: onTap,
    );
  }
}
