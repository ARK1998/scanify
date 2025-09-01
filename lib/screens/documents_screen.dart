// screens/documents_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/document_card.dart';
import '../models/document.dart'; 

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final List<Document> _documents = [
    Document(
      id: '1',
      title: 'Business Contract',
      createdDate: DateTime.now().subtract(const Duration(days: 2)),
      imagePath: 'https://via.placeholder.com/300x400/2563EB/FFFFFF?text=Contract',
      pdfPath: 'documents/contract.pdf',
      pageCount: 5,
    ),
    Document(
      id: '2',
      title: 'Receipt April 2023',
      createdDate: DateTime.now().subtract(const Duration(days: 5)),
      imagePath: 'https://via.placeholder.com/300x400/10B981/FFFFFF?text=Receipt',
      pdfPath: 'documents/receipt.pdf',
      pageCount: 1,
    ),
    Document(
      id: '3',
      title: 'Meeting Notes',
      createdDate: DateTime.now().subtract(const Duration(days: 7)),
      imagePath: 'https://via.placeholder.com/300x400/8B5CF6/FFFFFF?text=Notes',
      pdfPath: 'documents/notes.pdf',
      pageCount: 3,
    ),
    Document(
      id: '4',
      title: 'Tax Document',
      createdDate: DateTime.now().subtract(const Duration(days: 10)),
      imagePath: 'https://via.placeholder.com/300x400/EF4444/FFFFFF?text=Tax+Doc',
      pdfPath: 'documents/tax.pdf',
      pageCount: 12,
    ),
  ];

  final List<Document> _filteredDocuments = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  SortOption _sortOption = SortOption.dateDesc;

  @override
  void initState() {
    super.initState();
    _filteredDocuments.addAll(_documents);
    _sortDocuments();
  }

  void _filterDocuments(String query) {
    setState(() {
      _searchQuery = query;
      _filteredDocuments.clear();
      
      if (query.isEmpty) {
        _filteredDocuments.addAll(_documents);
      } else {
        _filteredDocuments.addAll(
          _documents.where((doc) => 
            doc.title.toLowerCase().contains(query.toLowerCase()) ||
            DateFormat('MMM d, yyyy').format(doc.createdDate).toLowerCase().contains(query.toLowerCase())
          ).toList()
        );
      }
      
      _sortDocuments();
    });
  }

  void _sortDocuments() {
    setState(() {
      switch (_sortOption) {
        case SortOption.nameAsc:
          _filteredDocuments.sort((a, b) => a.title.compareTo(b.title));
          break;
        case SortOption.nameDesc:
          _filteredDocuments.sort((a, b) => b.title.compareTo(a.title));
          break;
        case SortOption.dateAsc:
          _filteredDocuments.sort((a, b) => a.createdDate.compareTo(b.createdDate));
          break;
        case SortOption.dateDesc:
          _filteredDocuments.sort((a, b) => b.createdDate.compareTo(a.createdDate));
          break;
      }
    });
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sort by',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ...SortOption.values.map((option) {
                return ListTile(
                  leading: Icon(
                    _sortOption == option ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: _sortOption == option ? const Color(0xFF2563EB) : Colors.grey,
                  ),
                  title: Text(
                    option.displayName,
                    style: TextStyle(
                      fontWeight: _sortOption == option ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _sortOption = option;
                      _sortDocuments();
                    });
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFF2563EB),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Text(
                        'My Documents',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search documents...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _filterDocuments('');
                                },
                              )
                            : null,
                      ),
                      onChanged: _filterDocuments,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.sort),
                      onPressed: _showSortDialog,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _filteredDocuments.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No documents yet'
                              : 'No documents found',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_searchQuery.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Scan your first document to get started',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.7,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return DocumentCard(document: _filteredDocuments[index]);
                      },
                      childCount: _filteredDocuments.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

enum SortOption {
  nameAsc,
  nameDesc,
  dateAsc,
  dateDesc,
}

extension SortOptionExtension on SortOption {
  String get displayName {
    switch (this) {
      case SortOption.nameAsc:
        return 'Name (A-Z)';
      case SortOption.nameDesc:
        return 'Name (Z-A)';
      case SortOption.dateAsc:
        return 'Date (Oldest first)';
      case SortOption.dateDesc:
        return 'Date (Newest first)';
    }
  }
}