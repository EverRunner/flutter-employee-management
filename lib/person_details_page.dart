import 'package:employees_catalogue/data/component.dart';
import 'package:employees_catalogue/data/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:employees_catalogue/data/extensions.dart';

class PersonDetailsPage extends StatefulWidget {
  final int? personId;

  const PersonDetailsPage({Key? key, required this.personId}) : super(key: key);

  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  Person? person;

  @override
  void initState() {
    super.initState();
    if (widget.personId != null) {
      person = Component.instance.api.getPerson(widget.personId!);
      if (person == null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context);
        });
      }
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (person == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Person details'),
          leading: CloseButton(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Person details'),
        leading: CloseButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              person!.fullName,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 16),
            Text(
              'Responsibility: ${person!.responsibility.toNameString()}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 8),
            Text(
              'Room: ${person!.room}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 8),
            Text(
              'Phone: ${person!.phone}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 8),
            Text(
              'Email: ${person!.email}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}
