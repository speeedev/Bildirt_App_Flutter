import 'package:bildirt/src/core/constants/color_constants.dart';
import 'package:bildirt/src/screens/notification_detail/notification_detail_view_model.dart';
import 'package:flutter/material.dart';

class NotificationDetailView extends StatefulWidget {
  const NotificationDetailView({super.key});

  @override
  State<NotificationDetailView> createState() => _NotificationDetailViewState();
}

class _NotificationDetailViewState extends State<NotificationDetailView> {
  NotificationDetailViewModel viewModel = NotificationDetailViewModel();

  TextEditingController NotificationIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Detail'),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            buildNotificationIdTextFormField(),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await viewModel.getNotificationDetail(NotificationIdController
                      .text); // 4217-7095-7222-2067-7129
                  setState(() {});
                },
                child: const Text('Get Notification Detail'),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              child: StreamBuilder<bool>(
                stream: viewModel.isLoadingStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return buildNotificationDetailWidget();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNotificationDetailWidget() {
    if (viewModel.result.isEmpty) {
      return const Text(
        "Please input push ID.",
        style: TextStyle(fontSize: 25),
      );
    } else {
      if (viewModel.result.containsKey("error")) {
        return Text(
          viewModel.result["error"],
          style: const TextStyle(fontSize: 25),
        );
      } else {
        final Map notification = viewModel.result;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDetailRow("Title", notification["title"]),
            buildDetailRow("Body", notification["body"]),
            buildDetailRow("URL", notification["url"]),
            buildDetailRow(
                "Total Devices", notification["total_devices"].toString()),
            buildDetailRow(
                "Sent Devices", notification["sent_devices"].toString()),
            buildDetailRow("Click", notification["click"].toString()),
          ],
        );
      }
    }
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        "- $label: $value",
        style: const TextStyle(fontSize: 25),
      ),
    );
  }

  TextFormField buildNotificationIdTextFormField() {
    return TextFormField(
      controller: NotificationIdController,
      decoration: const InputDecoration(
        labelText: 'Notification ID',
        border: OutlineInputBorder(),
      ),
    );
  }
}
/*
Text(
                      'Please enter push ID.',
                      style: TextStyle(
                        color: Color(BLACK_COLOR),
                        fontSize: 22,
                      ),
                    ),
*/