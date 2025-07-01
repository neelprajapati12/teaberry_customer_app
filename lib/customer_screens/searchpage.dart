import 'package:flutter/material.dart';
import 'package:teaberryapp_project/constants/app_colors.dart';
import 'package:teaberryapp_project/constants/customtextformfield.dart';
import 'package:teaberryapp_project/customer_screens/product_detailspage.dart';
import 'package:teaberryapp_project/models/customer_model.dart';
// Import your model file here
// import 'your_model_file.dart';

// Search Result Model to hold both subproduct and parent inventory info
class SearchResult {
  final SubProducts subProduct;
  final Inventories parentInventory;
  final Stores parentStore;

  SearchResult({
    required this.subProduct,
    required this.parentInventory,
    required this.parentStore,
  });

  @override
  String toString() {
    return 'SearchResult(subProduct: ${subProduct.name}, '
        'price: ${subProduct.price}, '
        'quantity: ${subProduct.quantity}, '
        'parentInventory: ${parentInventory.name}, '
        'parentStore: ${parentStore.name})';
  }
}

class SearchScreen extends StatefulWidget {
  final CustomerModel customerData;

  const SearchScreen({Key? key, required this.customerData}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    List<SearchResult> results = [];

    // Search through all stores
    if (widget.customerData.stores != null) {
      for (Stores store in widget.customerData.stores!) {
        if (store.inventories != null) {
          // Search through all inventories in each store
          for (var inventory in store.inventories!.cast<Inventories>()) {
            if (inventory.subProducts != null) {
              // Search through all sub-products in each inventory
              for (SubProducts subProduct in inventory.subProducts!) {
                if (subProduct.name != null &&
                    subProduct.name!.toLowerCase().contains(query)) {
                  results.add(
                    SearchResult(
                      subProduct: subProduct,
                      parentInventory: inventory,
                      parentStore: store,
                    ),
                  );
                }
              }
            }
          }
        }
      }
    }

    // Also search in the main store if it exists
    if (widget.customerData.store?.inventories != null) {
      for (Inventories inventory in widget.customerData.store!.inventories!) {
        if (inventory.subProducts != null) {
          for (SubProducts subProduct in inventory.subProducts!) {
            if (subProduct.name != null &&
                subProduct.name!.toLowerCase().contains(query)) {
              // Create a dummy store object for main store
              Stores mainStore = Stores(
                id: widget.customerData.store!.id,
                name: widget.customerData.store!.name,
                location: widget.customerData.store!.location,
                photoUrl: widget.customerData.store!.photoUrl,
              );

              results.add(
                SearchResult(
                  subProduct: subProduct,
                  parentInventory: inventory,
                  parentStore: mainStore,
                ),
              );
            }
          }
        }
      }
    }

    setState(() {
      _searchResults = results;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          'Search Page',
          style: TextStyle(
            // fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          //  SizedBox(
          //         width: 0.9 * w,
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          // SizedBox(
          //   width: 0.92 * w,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: CustomTextFormField(
          //       controller: _searchController,
          //       hintText: 'Search here...',
          //     ),
          //   ),
          // ),
          // Search TextField
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              cursorColor: Colors.black,
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Search here...',
                prefixIcon: Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                        : null,
                hintStyle: TextStyle(color: Colors.black38),
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                // Apply the same border style to all states
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Search Results
          Expanded(
            child:
                _searchResults.isEmpty && _searchController.text.isNotEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No results found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                    : _searchResults.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Start typing to search',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final result = _searchResults[index];
                        print(result);
                        final subProduct = result.subProduct;
                        final parentInventory = result.parentInventory;
                        final parentStore = result.parentStore;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              print(result);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ProductDetailspage(
                                        subproduct: result.subProduct,
                                        productId: result.parentInventory.id,
                                      ),
                                ),
                              );
                            },
                            child: Card(
                              color: const Color.fromARGB(255, 243, 243, 243),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child:
                                          subProduct.photoUrl != null
                                              ? Image.network(
                                                subProduct.photoUrl!,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              )
                                              : Image.asset(
                                                'assets/iamges/coffee.jpg',
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            subProduct.name!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                          // Text(
                                          //   '❤️ Loved By ${item['likedBy']}',
                                          //   style: TextStyle(fontSize: 12),
                                          // ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '₹${subProduct.price}',
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Appcolors.green,
                                                size: 28,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

// // Product Details Page
// class ProductDetailsPage extends StatelessWidget {
//   final SearchResult searchResult;

//   const ProductDetailsPage({Key? key, required this.searchResult})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final subProduct = searchResult.subProduct;
//     final inventory = searchResult.parentInventory;
//     final store = searchResult.parentStore;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(inventory.name ?? 'Product Details'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Selected Sub Product Details
//             Card(
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Selected Sub Product',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue,
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     Row(
//                       children: [
//                         subProduct.photoUrl != null
//                             ? Image.network(
//                               subProduct.photoUrl!,
//                               width: 80,
//                               height: 80,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return Container(
//                                   width: 80,
//                                   height: 80,
//                                   color: Colors.grey[300],
//                                   child: Icon(Icons.shopping_bag),
//                                 );
//                               },
//                             )
//                             : Container(
//                               width: 80,
//                               height: 80,
//                               color: Colors.grey[300],
//                               child: Icon(Icons.shopping_bag),
//                             ),
//                         SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 subProduct.name ?? 'Unknown Product',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Price: \$${subProduct.price?.toStringAsFixed(2) ?? '0.00'}',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.green,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               Text(
//                                 'Available: ${subProduct.quantity ?? 0}',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[700],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             SizedBox(height: 20),

//             // Store and Inventory Information
//             Text(
//               'Store & Inventory Information',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 12),
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildInfoRow('Store Name:', store.name ?? 'Unknown'),
//                     _buildInfoRow(
//                       'Store Location:',
//                       store.location ?? 'Not specified',
//                     ),
//                     _buildInfoRow(
//                       'Inventory Name:',
//                       inventory.name ?? 'Unknown',
//                     ),
//                     _buildInfoRow(
//                       'Total Inventory Quantity:',
//                       '${inventory.quantity ?? 0}',
//                     ),
//                     _buildInfoRow(
//                       'Sub Products Count:',
//                       '${inventory.subProducts?.length ?? 0}',
//                     ),
//                     if (inventory.createdAt != null)
//                       _buildInfoRow(
//                         'Created:',
//                         _formatDate(inventory.createdAt!),
//                       ),
//                     if (inventory.updatedAt != null)
//                       _buildInfoRow(
//                         'Last Updated:',
//                         _formatDate(inventory.updatedAt!),
//                       ),
//                   ],
//                 ),
//               ),
//             ),

//             SizedBox(height: 20),

//             // All Sub Products in this inventory
//             Text(
//               'All Sub Products in this Inventory',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 12),
//             Expanded(
//               child:
//                   inventory.subProducts?.isNotEmpty == true
//                       ? ListView.builder(
//                         itemCount: inventory.subProducts!.length,
//                         itemBuilder: (context, index) {
//                           final currentSubProduct =
//                               inventory.subProducts![index];
//                           final isSelected =
//                               currentSubProduct.id == subProduct.id;

//                           return Card(
//                             color: isSelected ? Colors.blue[50] : null,
//                             child: ListTile(
//                               leading: Icon(
//                                 Icons.shopping_bag_outlined,
//                                 color: isSelected ? Colors.blue : Colors.grey,
//                               ),
//                               title: Text(
//                                 currentSubProduct.name ?? 'Unknown Product',
//                                 style: TextStyle(
//                                   fontWeight:
//                                       isSelected
//                                           ? FontWeight.bold
//                                           : FontWeight.normal,
//                                 ),
//                               ),
//                               subtitle: Text(
//                                 'Price: \$${currentSubProduct.price?.toStringAsFixed(2) ?? '0.00'}',
//                               ),
//                               trailing: Text(
//                                 'Qty: ${currentSubProduct.quantity ?? 0}',
//                               ),
//                             ),
//                           );
//                         },
//                       )
//                       : Center(
//                         child: Text(
//                           'No sub-products available',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 140,
//             child: Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
//           ),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }

//   String _formatDate(String dateString) {
//     try {
//       final date = DateTime.parse(dateString);
//       return '${date.day}/${date.month}/${date.year}';
//     } catch (e) {
//       return dateString;
//     }
//   }
// }
