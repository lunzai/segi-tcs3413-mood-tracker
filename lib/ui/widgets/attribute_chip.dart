// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mood_tracker/core/models/attribute.dart';
import 'package:mood_tracker/core/utils/colors.dart';

class AttributeChip extends StatefulWidget {
  final List<Attribute> list;
  final Function(List<Attribute>, Attribute, bool) onChange;
  List<Attribute> selectedList = [];

  AttributeChip({
    super.key,
    List<Attribute>? selectedList,
    required this.list,
    required this.onChange,
  }) : 
    selectedList = selectedList ?? [];

  @override
  State<AttributeChip> createState() => _AttributeChipState();
}

class _AttributeChipState extends State<AttributeChip> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 0,
      children: widget.list.map((Attribute e) {
        // final isSelected = widget.selectedList.any((Attribute item) => item.id == e.id);
        final isSelected = widget.selectedList.contains(e);
        return FilterChip(
          showCheckmark: false,
          selectedColor: AppColors.indigo50,
          label: Text(e.label), 
          labelStyle: TextStyle(
            color: isSelected ? AppColors.indigo500 : AppColors.black,
            fontWeight: FontWeight.w600,
            height: 1
          ),
          side: BorderSide(
            width: 2,
            color: isSelected ? AppColors.indigo500 : AppColors.black,
          ),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                widget.selectedList.add(e);
              } else {
                widget.selectedList.remove(e);
              }
              widget.onChange(widget.selectedList, e, selected);
            });
          }
        );
      }).toList(),
    );
  }
}