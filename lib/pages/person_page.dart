import 'package:cinema_scope/architecture/config_view_model.dart';
import 'package:cinema_scope/constants.dart';
import 'package:cinema_scope/utilities/common_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:cinema_scope/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../architecture/person_view_model.dart';

class PersonPage extends MultiProvider {
  PersonPage({
    super.key,
    required int id,
    required String name,
    required String? profilePath,
    required int? gender,
    required String knownForDepartment,
  }) : super(
            providers: [
              ChangeNotifierProvider(create: (_) => PersonViewModel()),
              // ChangeNotifierProvider(create: (_) => YoutubeViewModel()),
            ],
            child: _PersonPageChild(
              id: id,
              name: name,
              profilePath: profilePath,
              gender: gender,
              knownForDepartment: knownForDepartment,
            ));
}

class _PersonPageChild extends StatefulWidget {
  final int id;
  final String name;
  final String? profilePath;
  final int? gender;
  final String knownForDepartment;

  const _PersonPageChild({
    Key? key,
    required this.id,
    required this.name,
    required this.profilePath,
    required this.gender,
    required this.knownForDepartment,
  }) : super(key: key);

  @override
  State<_PersonPageChild> createState() => _PersonPageChildState();
}

class _PersonPageChildState extends State<_PersonPageChild>
    with Utilities, CommonFunctions {
  late final PersonViewModel pvm;

  @override
  void initState() {
    pvm = context.read<PersonViewModel>()..fetchPersonWithDetail(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // floating: true,
            pinned: true,
            // snap: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.40,
                        height: (MediaQuery.of(context).size.width * 0.40) /
                            Constants.arProfile *
                            0.8,
                        child: NetworkImageView(
                          widget.profilePath,
                          imageType: ImageType.profile,
                          aspectRatio: Constants.arProfile,
                          topRadius: 4.0,
                          bottomRadius: 4.0,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 24.0,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold,
                            // height: 1.1,
                          ),
                        ),
                        // getLabelView('NAME'),
                        // getTextView(widget.name),
                        // const SizedBox(height: 16.0,),
                        // getLabelView('GENDER'),
                        // getTextView(getGenderText(widget.gender)),
                        // const SizedBox(height: 16.0,),
                        // getLabelView('KNOWN FOR'),
                        getTextView(widget.knownForDepartment),
                        // const SizedBox(height: 16.0,),
                        // getLabelView('KNOWN FOR'),
                        // getTextView(widget.knownForDepartment),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getLabelView(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11.0,
        // height: 1.1,
        color: Colors.black54,
      ),
    );
  }

  Widget getTextView(String? text) {
    return Text(
      (text == null || text.isEmpty) ? '-' : text,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        // height: 1.1,
      ),
    );
  }
}
