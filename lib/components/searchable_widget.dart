import 'package:f3/components/MyTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchableList<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T)
      getItemText; // Function to get the display text for an item
  final void Function(T) onItemTap; // Function to handle item tap

  const SearchableList({
    Key? key,
    required this.items,
    required this.getItemText,
    required this.onItemTap,
  }) : super(key: key);

  @override
  _SearchableListState<T> createState() => _SearchableListState<T>();
}

class _SearchableListState<T> extends State<SearchableList<T>> {
  final TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  List<T> _filteredItems = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items); // Initialize with all items
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      _filteredItems = [];
    } else {
      _filteredItems = widget.items.where((item) {
        return widget
            .getItemText(item)
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          focusNode: _focusNode,
          onChanged: _filterItems,
          decoration: InputDecoration(
            hintText: 'What are you looking for?!....',
            hintStyle: TextStyle(color: Colors.deepOrange.withOpacity(0.4)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.deepOrange.withOpacity(0.4),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrange.shade100),
                borderRadius: BorderRadius.circular(16)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.deepOrange)),
          ),
        ),
        // Add some space between the search bar and the list
        _filteredItems.isEmpty
            ? const Center(child: Text(''))
            : Container(
                height: 300,
                child: ListView.builder(
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    T item = _filteredItems[index];
                    return ListTile(
                      title: Text(widget.getItemText(item)),
                      onTap: () => widget.onItemTap(item),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
