enum DateSelection { today, nextMonday, nextTuesday, afterOneWeek, noDate }

extension ButtonText on DateSelection {
  String getButtonText() {
    switch (this) {
      case DateSelection.today:
        return "Today";

      case DateSelection.nextMonday:
        return "Next Monday";

      case DateSelection.nextTuesday:
        return "Next Tuesday";

      case DateSelection.afterOneWeek:
        return "After 1 week";

      case DateSelection.noDate:
        return "No Date";
    }
  }
}
