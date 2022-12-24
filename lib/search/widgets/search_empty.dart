import 'package:flutter/material.dart';

class SearchEmpty extends StatelessWidget {
  final List<String> recentSearchs;
  final Function? onItemTap;
  final Function? onItemRemove;
  final Function? onClear;

  const SearchEmpty(
      {super.key,
      required this.recentSearchs,
      this.onItemTap,
      this.onItemRemove,
      this.onClear});

  @override
  Widget build(BuildContext context) {
    if (recentSearchs.isEmpty) {
      return const Center(
        child: Text("Digite o termo da busca"),
      );
    }
    return ListView.separated(
      itemCount: recentSearchs.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Text(
                  'Buscas recentes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => onClear?.call(),
                  child: const Text('limpar'),
                ),
              ],
            ),
          );
        }
        return ListTile(
          onTap: () {
            onItemTap?.call(recentSearchs[index - 1]);
          },
          title: Row(
            children: [
              Expanded(
                child: Text(recentSearchs[index - 1]),
              ),
              InkWell(
                onTap: (() {
                  onItemRemove?.call(recentSearchs[index - 1]);
                }),
                child: const Icon(
                  Icons.clear,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}
