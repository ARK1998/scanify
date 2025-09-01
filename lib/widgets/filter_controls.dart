// widgets/filter_controls.dart
import 'package:flutter/material.dart';
import '../models/filter_type.dart';

class FilterControls extends StatefulWidget {
  final Function(FilterType) onFilterChanged;
  final FilterType initialFilter;

  const FilterControls({
    super.key,
    required this.onFilterChanged,
    this.initialFilter = FilterType.original,
  });

  @override
  _FilterControlsState createState() => _FilterControlsState();
}

class _FilterControlsState extends State<FilterControls> {
  late FilterType _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
  }

  void _selectFilter(FilterType filter) {
    setState(() {
      _selectedFilter = filter;
    });
    widget.onFilterChanged(filter);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Filters',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildFilterOption(
                  filter: FilterType.original,
                  label: 'Original',
                  icon: Icons.photo,
                ),
                _buildFilterOption(
                  filter: FilterType.grayscale,
                  label: 'B&W',
                  icon: Icons.filter_b_and_w,
                ),
                _buildFilterOption(
                  filter: FilterType.binary,
                  label: 'Binary',
                  icon: Icons.invert_colors,
                ),
                _buildFilterOption(
                  filter: FilterType.enhanced,
                  label: 'Enhanced',
                  icon: Icons.auto_awesome,
                ),
                _buildFilterOption(
                  filter: FilterType.sepia,
                  label: 'Sepia',
                  icon: Icons.filter,
                ),
                _buildFilterOption(
                  filter: FilterType.magicColor,
                  label: 'Magic',
                  icon: Icons.color_lens,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption({
    required FilterType filter,
    required String label,
    required IconData icon,
  }) {
    final bool isSelected = _selectedFilter == filter;
    
    return GestureDetector(
      onTap: () => _selectFilter(filter),
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}