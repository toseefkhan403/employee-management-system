import 'package:flutter/material.dart';

import '../data/models/role.dart';

class SelectRoleBottomSheet extends StatelessWidget {
  const SelectRoleBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        roleListTile(Role.productDesigner, context),
        roleListTile(Role.flutterDeveloper, context),
        roleListTile(Role.qaTester, context),
        roleListTile(Role.productOwner, context),
      ],
    );
  }

  roleListTile(Role role, context) => Column(
        children: [
          ListTile(
            title: Text(
              role.getRoleName(),
              textAlign: TextAlign.center,
            ),
            onTap: () {
              Navigator.pop(context, role);
            },
          ),
          const Divider(height: 0,),
        ],
      );
}
