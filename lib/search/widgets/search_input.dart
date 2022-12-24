import 'package:flutter/material.dart';
import 'package:tabnews_app/extensions/dark_mode.dart';

class SearchInput extends StatefulWidget {
  final Function onCancel;
  final Function onSubmitted;
  final TextEditingController? textEditingController;

  const SearchInput({
    super.key,
    required this.onCancel,
    required this.onSubmitted,
    this.textEditingController,
  });

  @override
  State<StatefulWidget> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final focusNode = FocusNode();
  late TextEditingController controller;

  bool hasText = false;
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_onFocusChange);
    controller = widget.textEditingController ?? TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      hasFocus = focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = context.isDarkMode
        ? const Color.fromRGBO(165, 165, 167, 1)
        : const Color.fromRGBO(138, 143, 148, 1);

    const border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );

    return SizedBox(
      height: 36,
      child: TextField(
        onSubmitted: (value) {
          if (value != '') {
            widget.onSubmitted(value);
          }
        },
        onChanged: (value) {
          setState(() {
            hasText = value != '';
          });
        },
        focusNode: focusNode,
        controller: controller,
        cursorColor: context.isDarkMode ? Colors.white : Colors.black,
        keyboardAppearance:
            context.isDarkMode ? Brightness.dark : Brightness.light,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: iconColor,
          ),
          suffixIcon: hasFocus || hasText
              ? Padding(
                  padding: EdgeInsets.zero,
                  child: InkWell(
                    onTap: () {
                      controller.clear();
                      FocusScope.of(context).unfocus();
                      widget.onCancel();
                      setState(() {
                        hasText = false;
                      });
                    },
                    child: Icon(
                      Icons.cancel,
                      color: iconColor,
                    ),
                  ),
                )
              : null,
          hintText: 'Digite o termo da busca',
          contentPadding: EdgeInsets.zero,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          enabledBorder: border,
          focusedBorder: border,
          fillColor: context.isDarkMode
              ? const Color.fromRGBO(87, 87, 87, 1)
              : const Color.fromRGBO(222, 224, 226, 1),
          filled: true,
          isDense: true,
        ),
      ),
    );
  }
}
