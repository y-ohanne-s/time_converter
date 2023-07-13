import 'package:intl/intl.dart';

class HelperFuncitons {
  static List getFormattedZones(zones) {
    ({String countryCode, String countryName, String zoneName, int timestamp}) zoneData;
    List<({String countryCode, String countryName, String zoneName, int timestamp})>
        formattedZones = [];

    for (var zone in zones) {
      zoneData = (
        countryCode: zone['countryCode'],
        countryName: zone['countryName'],
        zoneName: zone['zoneName'].toString().split('/').last,
        timestamp: zone['timestamp'],
      );

      formattedZones.add(zoneData);
    }

    return sortByCountryName(formattedZones);
  }

  static String getGMTTimeFromTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toUtc();

    // String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    String formattedTime = DateFormat('HH:mm').format(date);

    return formattedTime;
  }

  static String geTimeFromTimestamp(int timestamp, {bool isUtc = false}) {
    DateTime utc = DateTime.fromMillisecondsSinceEpoch(timestamp).toUtc();
    DateTime date = isUtc ? utc : utc.toLocal();

    // String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    String formattedTime = DateFormat('HH:mm').format(date);

    return formattedTime;
  }

  static List sortByCountryName(List zones) {
    zones.sort((a, b) => a.countryName.compareTo(b.countryName));

    return zones;
  }

  static Object getFormattedConvertedTimeData(data) {
    ({String fromZone, String toZone, int fromTimestamp, int toTimestamp}) timeData;

    timeData = (
      fromZone: data['fromZoneName'],
      toZone: data['toZoneName'],
      fromTimestamp: data['fromTimestamp'],
      toTimestamp: data['toTimestamp'],
    );

    return timeData;
  }
}
