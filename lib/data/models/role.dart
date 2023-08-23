enum Role {
  productDesigner,
  flutterDeveloper,
  qaTester,
  productOwner;
}

extension RoleNames on Role {
  String getRoleName() {
    switch (this) {
      case Role.productDesigner:
        return "Product Designer";

      case Role.flutterDeveloper:
        return "Flutter Developer";

      case Role.qaTester:
        return "QA Tester";

      case Role.productOwner:
        return "Product Owner";
    }
  }
}
