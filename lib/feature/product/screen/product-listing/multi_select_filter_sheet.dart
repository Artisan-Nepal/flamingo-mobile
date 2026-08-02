import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class MultiSelectOption {
  final String value;
  final String label;
  const MultiSelectOption({required this.value, required this.label});
}

/// Generic multi-select checkbox bottom sheet used by the brand-page filters
/// ("Choose category", "Choose size"). Returns the new selection on Apply, or
/// null if dismissed without applying. Includes a search box so a long option
/// list (a brand can span many categories) stays usable.
Future<Set<String>?> showMultiSelectFilterSheet({
  required BuildContext context,
  required String title,
  required List<MultiSelectOption> options,
  required Set<String> initialSelected,
}) {
  return showModalBottomSheet<Set<String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => _MultiSelectFilterSheet(
      title: title,
      options: options,
      initialSelected: initialSelected,
    ),
  );
}

class _MultiSelectFilterSheet extends StatefulWidget {
  const _MultiSelectFilterSheet({
    required this.title,
    required this.options,
    required this.initialSelected,
  });

  final String title;
  final List<MultiSelectOption> options;
  final Set<String> initialSelected;

  @override
  State<_MultiSelectFilterSheet> createState() =>
      _MultiSelectFilterSheetState();
}

class _MultiSelectFilterSheetState extends State<_MultiSelectFilterSheet> {
  late Set<String> _selected = {...widget.initialSelected};
  String _query = '';

  bool get _showSearch => widget.options.length > 8;

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? widget.options
        : widget.options
            .where((o) => o.label.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: Dimens.spacingSizeSmall),
              // grab handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grayLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Dimens.spacingSizeDefault),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: Dimens.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_selected.isNotEmpty)
                      TextButton(
                        onPressed: () => setState(() => _selected.clear()),
                        child: const Text('Clear'),
                      ),
                  ],
                ),
              ),
              if (_showSearch)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacingSizeDefault,
                  ),
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      style: const TextStyle(fontSize: Dimens.fontSizeDefault),
                      decoration: InputDecoration(
                        hintText: 'Search…',
                        hintStyle: const TextStyle(
                          fontSize: Dimens.fontSizeDefault,
                          color: AppColors.grayMain,
                        ),
                        prefixIcon:
                            const Icon(Icons.search, size: Dimens.iconSizeSmall),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: Dimens.spacingSizeSmall,
                        ),
                        filled: true,
                        fillColor: AppColors.grayLighter,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Dimens.radiusDefault),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Dimens.radiusDefault),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Dimens.radiusDefault),
                          borderSide: const BorderSide(color: AppColors.grayLight),
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No options'))
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final o = filtered[i];
                          final checked = _selected.contains(o.value);
                          return CheckboxListTile(
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: themedPrimaryColor(context),
                            title: Text(o.label),
                            value: checked,
                            onChanged: (v) => setState(() {
                              if (v == true) {
                                _selected.add(o.value);
                              } else {
                                _selected.remove(o.value);
                              }
                            }),
                          );
                        },
                      ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.spacingSizeDefault),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, _selected),
                      child: Text(
                        _selected.isEmpty
                            ? 'Apply'
                            : 'Apply (${_selected.length})',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
