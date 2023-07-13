import 'package:flutter/material.dart';
import 'package:time_converter/helper.dart';
import 'package:time_converter/request.dart';

class TimeZoneListScreen extends StatelessWidget {
  const TimeZoneListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder(
      future: ApiRequest.getTimeZoneList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 1),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (snapshot.hasData) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1024) {
                return SingleChildScrollView(
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      for (var data in snapshot.data)
                        Container(
                          height: constraints.maxWidth * 0.08,
                          width: constraints.maxWidth * 0.3,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              width: 0.3,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${data.countryName} / ${data.zoneName.replaceAll(RegExp(r'_'), " ")}',
                                style: theme.textTheme.headlineSmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                HelperFuncitons.getGMTTimeFromTimestamp(data.timestamp),
                                style: theme.textTheme.displayMedium!
                                    .copyWith(fontWeight: FontWeight.w200),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              }
              if (constraints.maxWidth > 600) {
                return SingleChildScrollView(
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 5,
                    runSpacing: 5,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      for (var data in snapshot.data)
                        Container(
                          height: constraints.maxWidth * 0.2,
                          width: constraints.maxWidth * 0.48,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              width: 0.3,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${data.countryName} / ${data.zoneName.replaceAll(RegExp(r'_'), " ")}',
                                style: theme.textTheme.headlineSmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                HelperFuncitons.getGMTTimeFromTimestamp(data.timestamp),
                                style: theme.textTheme.displayMedium!
                                    .copyWith(fontWeight: FontWeight.w200),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                itemCount: snapshot.data.length,
                padding: const EdgeInsets.symmetric(vertical: 10),
                separatorBuilder: (context, index) => Divider(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  thickness: 0.5,
                  indent: 30,
                  endIndent: 80,
                ),
                itemBuilder: (context, index) {
                  final data = snapshot.data[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 35),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${data.countryName} / ${data.zoneName.replaceAll(RegExp(r'_'), " ")}',
                          style: theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          HelperFuncitons.getGMTTimeFromTimestamp(data.timestamp),
                          style:
                              theme.textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        }

        return const Center(
          child: Text('No data'),
        );
      },
    );
  }
}
