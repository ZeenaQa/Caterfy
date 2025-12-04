import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/outlined_icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DeliveredByInfo extends StatelessWidget {
  const DeliveredByInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: OutlinedIconBtn(
              onPressed: () => Navigator.of(context).pop(),
              size: 40,
              child: Icon(
                FontAwesomeIcons.x,
                color: colors.onSurface,
                size: 14,
              ),
            ),
          ),
          SizedBox(height: 5),
          SvgPicture.asset(
            'assets/icons/caterfy_scooter.svg',
            width: 130,
            height: 130,
          ),
          SizedBox(height: 60),
          RichText(
            text: TextSpan(
              text: '${l10.deliveredBy} ',
              style: TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
              children: [
                TextSpan(
                  text: "Caterfy",
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(l10.deliverByDesc),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              spacing: 20,
              children: [
                InfoItem(
                  iconName: 'caterfy_pin.svg',
                  title: l10.trackYourOrder,
                  desc: l10.trackOrderDesc,
                ),
                InfoItem(
                  iconName: 'caterfy_helmet.svg',
                  title: l10.onTimeDelivery,
                  desc: l10.onTimeDeliveryDesc,
                ),
                InfoItem(
                  iconName: 'caterfy_headset.svg',
                  title: l10.chatAgentsTitle,
                  desc: l10.chatAgentsInfo,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  const InfoItem({
    super.key,
    required this.title,
    required this.desc,
    required this.iconName,
  });

  final String title;
  final String desc;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 15,
      children: [
        SvgPicture.asset('assets/icons/$iconName', width: 43, height: 43),
        Expanded(
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                desc,
                style: TextStyle(
                  color: colors.onSurface,
                  height: 1.3,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
