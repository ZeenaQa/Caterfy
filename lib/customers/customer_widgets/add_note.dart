import 'package:flutter/material.dart';
import 'package:caterfy/l10n/app_localizations.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key, this.onCloseNote, this.initialNote = ''});

  final Function? onCloseNote;
  final String initialNote;

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialNote;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (widget.onCloseNote == null) return;
        widget.onCloseNote!(controller.text);
        if (didPop) return;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 15),
          TextField(
            controller: controller,
            maxLines: 4,
            minLines: 4,
            maxLength: 200,
            autofocus: true,
            decoration: InputDecoration(
              label: Text(l10.specialRequest),
              floatingLabelAlignment: FloatingLabelAlignment.start,
              floatingLabelStyle: TextStyle(color: colors.onSurfaceVariant),
              border: OutlineInputBorder(),
              filled: true,
              // fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 16, height: 1.25),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
