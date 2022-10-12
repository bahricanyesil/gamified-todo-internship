import 'package:flutter/material.dart';

import '../../../constants/enums/enums_shelf.dart';
import '../../../decoration/input_decoration.dart';
import '../../../decoration/text_styles.dart';
import '../../../extensions/context/responsiveness_extensions.dart';
import '../../../theme/color/l_colors.dart';
import '../../list/custom_checkbox_tile.dart';
import '../../list/default_list_view_builder.dart';

/// Item selection callback definiton.
typedef ItemSelection<T> = void Function(List<T> items);

/// A choose dialog with multiple options.
class MultipleChooseDialog<T> extends StatefulWidget {
  /// Default constructor of [MultipleChooseDialog].
  const MultipleChooseDialog({
    required this.elements,
    this.enableSearch = false,
    this.initialSelecteds,
    this.onValueChanged,
    Key? key,
  }) : super(key: key);

  /// All possible elements.
  final List<T> elements;

  /// Enables or disables search
  final bool enableSearch;

  /// Initial selected values.
  final List<T>? initialSelecteds;

  /// Callback to notify parent on value changes.
  final ItemSelection<T>? onValueChanged;

  @override
  _MultipleChooseDialogState<T> createState() =>
      _MultipleChooseDialogState<T>();
}

class _MultipleChooseDialogState<T> extends State<MultipleChooseDialog<T>> {
  String searchText = '';
  List<T> _selectedItems = <T>[];
  List<T> _searchedList = <T>[];
  late double _itemHeight;
  late double _maxMenuHeight;

  @override
  void initState() {
    super.initState();
    _searchedList = widget.elements;
    if ((widget.initialSelecteds ?? <T>[]).isNotEmpty) {
      _selectedItems = widget.initialSelecteds!.toSet().toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    _maxMenuHeight = context.height * 60;
    _itemHeight = context.height * 4.8;
    final double _menuHeight = _itemHeight * _searchedList.length;
    return SizedBox(
      width: context.width * 80,
      height: (_menuHeight > _maxMenuHeight ? _maxMenuHeight : _menuHeight) +
          (widget.enableSearch ? context.height * 6 : 0),
      child: widget.enableSearch
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _searchForm,
                Expanded(child: _itemList),
              ],
            )
          : _itemList,
    );
  }

  void getSearchResults(String val) {
    searchText = val;
    _searchedList = widget.elements
        .where((T e) =>
            e.toString().toLowerCase().startsWith(searchText.toLowerCase()))
        .toList();
  }

  Widget get _itemList => DefaultListViewBuilder(
        itemCount: _searchedList.length,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.only(top: context.height * .4),
          child: CustomCheckboxTile(
            key: UniqueKey(),
            initialValue: _selectedItems.contains(_searchedList[index]),
            onTap: (bool? val) => _chooseItem(index),
            text: _searchedList[index].toString(),
            color: AppColors.black,
          ),
        ),
      );

  Widget get _searchForm => Container(
        height: context.height * 4,
        margin: context.allPadding(Sizes.low),
        child: Material(
          color: Colors.transparent,
          child: TextField(
            style: TextStyles(context).textFormStyle(color: AppColors.black),
            decoration: InputDeco(context).underlinedDeco(hintText: 'Search'),
            onChanged: (String? val) {
              if (val == null) return;
              setState(() => getSearchResults(val));
            },
          ),
        ),
      );

  void _chooseItem(int index) {
    _selectedItems.contains(_searchedList[index])
        ? _selectedItems.remove(_searchedList[index])
        : _selectedItems.add(_searchedList[index]);
    if (widget.onValueChanged != null) {
      widget.onValueChanged!(_selectedItems.toSet().toList());
    }
    setState(() {});
  }
}
