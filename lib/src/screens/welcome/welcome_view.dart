import 'package:bildirt/src/core/constants/color_constants.dart';
import 'package:bildirt/src/screens/new_notification/new_notification_view.dart';
import 'package:bildirt/src/screens/notification_detail/notification_detail_view.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            buildButtonContainer(
              context,
              'New Notification',
              const Icon(Icons.add),
              false,
              () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewNotificationView(),
                    ),
                  );
                });
              },
            ),
            const SizedBox(height: 20),
            buildButtonContainer(
              context,
              'Notification Detail',
              const Icon(Icons.info_outline),
              true,
              () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationDetailView(),
                    ),
                  );
                });
              },
            )
          ],
        ),
      ),
      bottomSheet: const Text(
        "Coded by SpeeDEV",
      ),
    );
  }

  buildButtonContainer(BuildContext context, String title, Icon icon,
      bool leftIcon, void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(RED_COLOR),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 160,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leftIcon) Icon(icon.icon, size: 120),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (!leftIcon) Icon(icon.icon, size: 120),
          ],
        ),
      ),
    );
  }
}
