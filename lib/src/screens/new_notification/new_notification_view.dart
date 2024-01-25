import 'dart:ffi';

import 'package:bildirt/src/screens/new_notification/new_notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewNotificationView extends StatefulWidget {
  const NewNotificationView({super.key});

  @override
  State<NewNotificationView> createState() => _NewNotificationViewState();
}

class _NewNotificationViewState extends State<NewNotificationView> {
  bool scheduleNotification = false;
  DateTime selectedDateTime = DateTime.now();
  String ttlInHours = '';

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController ttlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("New Notification"),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            buildTextFormField("Title", titleController),
            const SizedBox(height: 15),
            buildTextFormField("Body", bodyController),
            const SizedBox(height: 15),
            buildTextFormField("URL", urlController),
            const SizedBox(height: 15),
            buildTextFormField("Image URL", imageUrlController),
            const SizedBox(height: 15),
            //time
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: buildNumberFormField("TTL", ttlController),
                ),
                const SizedBox(width: 5),
                const Text("seconds"),
              ],
            ),

            const SizedBox(height: 10),
            Text("TTL in hours: $ttlInHours"),
            Row(
              children: [
                const Text("Schedule? "),
                buildCheckboxField(),
              ],
            ),
            if (scheduleNotification)
              scheduleNotificationWidgets(context, setState),
            Spacer(),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  var result = await sendNotification(
                    context,
                    NewNotificationViewModel(),
                    titleController,
                    bodyController,
                    urlController,
                    imageUrlController,
                  );
                  if (result == true) {
                    showSnackBar(
                        context, "The notification was sent successfully.");
                  } else {
                    showSnackBar(context, "Failed to send notification");
                  }
                },
                child: const Text("Send Notification"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  Checkbox buildCheckboxField() {
    return Checkbox(
      value: scheduleNotification,
      onChanged: (value) {
        setState(() {
          scheduleNotification = value!;
        });
      },
    );
  }

  TextFormField buildTextFormField(
      String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  TextFormField buildNumberFormField(
      String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        convertSecondsToHours();
      },
    );
  }

  Column scheduleNotificationWidgets(
      BuildContext context, StateSetter setState) {
    return Column(
      children: [
        Row(
          children: [
            const Text("Schedule: "),
            TextButton(
              onPressed: () async {
                DateTime now = DateTime.now();
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialEntryMode: DatePickerEntryMode.input,
                  initialDate: selectedDateTime,
                  firstDate: DateTime(
                    now.year,
                    now.month,
                    now.day,
                  ),
                  lastDate: DateTime(now.year + 1),
                );

                if (picked != null && picked != selectedDateTime) {
                  setState(() {
                    selectedDateTime = picked;
                  });
                }
              },
              child: Text(
                DateFormat('yyyy-MM-dd').format(selectedDateTime),
              ),
            ),
            TextButton(
              onPressed: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialEntryMode: TimePickerEntryMode.input,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    selectedDateTime = DateTime(
                      selectedDateTime.year,
                      selectedDateTime.month,
                      selectedDateTime.day,
                      picked.hour,
                      picked.minute,
                    );
                  });
                }
              },
              child: Text(
                DateFormat('HH:mm').format(selectedDateTime),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void convertSecondsToHours() {
    int seconds = int.tryParse(ttlController.text) ?? 0;

    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    setState(() {
      ttlInHours = '$hours hours, $minutes minutes, $remainingSeconds seconds';
    });
  }

  Future sendNotification(
    BuildContext context,
    NewNotificationViewModel viewModel,
    TextEditingController titleController,
    TextEditingController bodyController,
    TextEditingController linkController,
    TextEditingController imageUrlController,
  ) async {
    DateTime notificationTime =
        scheduleNotification ? selectedDateTime : DateTime.now();

    String formatTime = DateFormat('yyyy-MM-dd HH:mm').format(notificationTime);
    var result = await viewModel.sendPushNotification(
      titleController.text,
      bodyController.text,
      linkController.text,
      imageUrlController.text,
      formatTime,
      scheduleNotification ? 1 : 0,
      ttlController.text,
    );
    return result;
  }
}
