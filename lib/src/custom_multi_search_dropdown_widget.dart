import 'dart:async';
import 'package:flutter/material.dart';

/// A customizable searchable dropdown widget for multi-item selection.
///
/// This widget provides a searchable list of items with checkboxes for multiple selection.
/// It supports both local and server-side filtering.
class CustomMultiSearchDropdownWidget<T> extends StatefulWidget {
  /// Creates a [CustomMultiSearchDropdownWidget].
  const CustomMultiSearchDropdownWidget({
    super.key,
    required this.onChanged,
    required this.itemsList,
    required this.backgroundColor,
    this.onSearch,
    required this.listItemBuilder,
    required this.headerBuilder,
    required this.selectedItems,
    this.isLoading = false,
    this.searchFieldDecoration,
    this.itemToString,
    this.headerDecoration,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.errorTextStyle,
    this.errorBorder,
    this.suffixIcon,
    this.headerPadding,
  });

  /// Optional decoration for the dropdown header.
  final Decoration? headerDecoration;

  /// Optional padding for the dropdown header.
  final EdgeInsetsGeometry? headerPadding;

  /// Optional custom icon for the dropdown header.
  final Widget? suffixIcon;

  /// Optional function to convert an item to a string for filtering.
  /// If not provided, `item.toString()` is used.
  final String Function(T item)? itemToString;

  /// Callback function called when the list of selected items changes.
  final void Function(List<T> values) onChanged;

  /// The list of items to display in the dropdown.
  final List<T> itemsList;

  /// Background color of the dropdown search panel.
  final Color backgroundColor;

  /// Optional callback for server-side search.
  /// If provided, local filtering is disabled.
  final void Function(String query)? onSearch;

  /// Builder for individual list items in the dropdown.
  final Widget Function(BuildContext context, T item, bool isSelected) listItemBuilder;

  /// Builder for the collapsed dropdown header (the button).
  final Widget Function(BuildContext context, List<T> selectedItems, bool enabled) headerBuilder;

  /// The list of currently selected items.
  final List<T> selectedItems;

  /// Indicates whether a search operation is in progress.
  final bool isLoading;

  /// Custom decoration for the search text field.
  final InputDecoration? searchFieldDecoration;

  /// Form field validation logic.
  final String? Function(List<T>? value)? validator;

  /// Autovalidate mode for the form field.
  final AutovalidateMode autovalidateMode;

  /// Style for the validation error text.
  final TextStyle? errorTextStyle;

  /// Border to show when there is a validation error.
  final BoxBorder? errorBorder;

  @override
  State<CustomMultiSearchDropdownWidget<T>> createState() => _CustomMultiSearchDropdownWidgetState<T>();
}

class _CustomMultiSearchDropdownWidgetState<T> extends State<CustomMultiSearchDropdownWidget<T>> {
  List<T> filteredList = [];
  final LayerLink layerLink = LayerLink();
  final GlobalKey buttonKey = GlobalKey();
  OverlayEntry? overlay;
  Timer? debounce;
  bool isToggle = false;
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    filteredList = List.from(widget.itemsList);
    searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(covariant CustomMultiSearchDropdownWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemsList != oldWidget.itemsList || widget.isLoading != oldWidget.isLoading) {
      if (widget.onSearch != null) {
        filteredList = List.from(widget.itemsList);
      } else {
        _applyLocalFilter(searchController.text);
      }

      if (overlay != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (overlay?.mounted ?? false) {
            overlay?.markNeedsBuild();
          }
        });
      }
    }
  }

  void _onSearchChanged() {
    final query = searchController.text;
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      if (widget.onSearch != null) {
        widget.onSearch!(query);
      } else {
        _applyLocalFilter(query);
      }
    });
  }

  void _applyLocalFilter(String query) {
    if (query.isEmpty) {
      if (mounted) {
        setState(() {
          filteredList = List.from(widget.itemsList);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          filteredList = widget.itemsList.where((item) {
            final String filterString = widget.itemToString?.call(item) ?? item.toString();
            return filterString.toLowerCase().contains(query.toLowerCase());
          }).toList();
        });
      }
    }
    if (overlay?.mounted ?? false) {
      overlay?.markNeedsBuild();
    }
  }

  void _toggleOverLay() {
    if (overlay == null) {
      isToggle = true;
      overlay = _buildOverlay();
      Overlay.of(context).insert(overlay!);
    } else {
      isToggle = false;
      if (overlay?.mounted ?? false) {
        overlay?.remove();
      }
      overlay = null;
      searchController.clear();
    }
    if (mounted) setState(() {});
  }

  void _removeOverlay() {
    if (overlay != null) {
      isToggle = false;
      if (overlay?.mounted ?? false) {
        overlay?.remove();
      }
      overlay = null;
      if (mounted) setState(() {});
    }
  }

  OverlayEntry _buildOverlay() {
    final RenderBox renderBox = buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    double screenHeight = MediaQuery.of(context).size.height;
    double distanceFromBottom = screenHeight - (position.dy + size.height);

    return OverlayEntry(
      builder: (context) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, res) async {
            if (didPop) _removeOverlay();
          },
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(color: const Color.fromARGB(45, 158, 158, 158)),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: InkWell(
                        overlayColor: WidgetStateProperty.all(Colors.transparent),
                        onTap: _removeOverlay,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                      ),
                    ),
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                        child: CompositedTransformFollower(
                          link: layerLink,
                          offset: MediaQuery.of(context).viewInsets.bottom > 0 && distanceFromBottom > 450
                              ? const Offset(0, -10)
                              : MediaQuery.of(context).viewInsets.bottom > 0 &&
                                      distanceFromBottom < 450 &&
                                      distanceFromBottom > 300
                                  ? const Offset(0, -100)
                                  : distanceFromBottom < 300
                                      ? const Offset(0, -300)
                                      : const Offset(0, 60),
                          showWhenUnlinked: false,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black26, blurRadius: 8.0, offset: Offset(0, 2))
                                ],
                              ),
                              child: _buildSearchPanel(width: size.width),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchPanel({double? width}) {
    return StatefulBuilder(
      builder: (BuildContext context, innerSetState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          height: 370,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8.0, offset: Offset(0, 2))],
          ),
          width: width ?? MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Search', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              TextField(
                autofocus: true,
                focusNode: _searchFocusNode,
                controller: searchController,
                decoration: widget.searchFieldDecoration ??
                    InputDecoration(
                      hintText: 'Search here...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      suffixIcon: const Icon(Icons.search),
                    ),
              ),
              const SizedBox(height: 10),
              if (widget.isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (filteredList.isNotEmpty) ...[
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.zero,
                    itemCount: filteredList.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      final isSelected = widget.selectedItems.contains(item);
                      return InkWell(
                        onTap: () {
                          final newSelection = List<T>.from(widget.selectedItems);
                          if (isSelected) {
                            newSelection.remove(item);
                          } else {
                            newSelection.add(item);
                          }
                          widget.onChanged(newSelection);
                          innerSetState(() {});
                          if (overlay?.mounted ?? false) {
                            overlay?.markNeedsBuild();
                          }
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: isSelected,
                              onChanged: (val) {
                                final newSelection = List<T>.from(widget.selectedItems);
                                if (isSelected) {
                                  newSelection.remove(item);
                                } else {
                                  newSelection.add(item);
                                }
                                widget.onChanged(newSelection);
                                innerSetState(() {});
                                if (overlay?.mounted ?? false) {
                                  overlay?.markNeedsBuild();
                                }
                              },
                            ),
                            Expanded(child: widget.listItemBuilder(context, item, isSelected)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ] else ...[
                const Expanded(
                  child: Center(
                    child: Text("No Result Found", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<T>>(
      initialValue: widget.selectedItems,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      builder: (FormFieldState<List<T>> state) {
        // Update the form field value when the widget's selectedItems changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (widget.selectedItems != state.value) {
            state.didChange(widget.selectedItems);
          }
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: CompositedTransformTarget(
                link: layerLink,
                child: Container(
                  decoration: state.hasError
                      ? (widget.errorBorder != null
                          ? (widget.headerDecoration is BoxDecoration
                              ? (widget.headerDecoration as BoxDecoration).copyWith(border: widget.errorBorder)
                              : BoxDecoration(border: widget.errorBorder))
                          : (widget.headerDecoration is BoxDecoration
                              ? (widget.headerDecoration as BoxDecoration).copyWith(border: Border.all(color: Colors.red))
                              : BoxDecoration(border: Border.all(color: Colors.red))))
                      : widget.headerDecoration,
                  child: InkWell(
                    key: buttonKey,
                    onTap: _toggleOverLay,
                    child: Padding(
                      padding: widget.headerPadding ?? const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(child: widget.headerBuilder(context, widget.selectedItems, true)),
                          const SizedBox(width: 8),
                          widget.suffixIcon ??
                              const RotatedBox(
                                quarterTurns: -45,
                                child: Icon(Icons.chevron_left, color: Color(0xFF757575), size: 20),
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 12),
                child: Text(
                  state.errorText ?? "",
                  style: widget.errorTextStyle ?? const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    searchController.dispose();
    _searchFocusNode.dispose();
    debounce?.cancel();
    super.dispose();
  }
}
