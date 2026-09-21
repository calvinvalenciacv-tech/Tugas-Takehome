import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
// test git
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CartPage(),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Wireless Headphone',
      'category': 'Sony WH-CH520',
      'price': 350000,
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3cXyV0tdw2OyJJYpg9BR4jkGyW6_09MMltv5EvSQq5A&s=10',
      'likes': 12,
      'quantity': 1,
      'selected': false,
      'liked': false,
    },
    {
      'name': 'Laptop ASUS Vivobook',
      'category': 'ASUS',
      'price': 7500000,
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZGB8PQs24sghQoPNQ_Uq4im3HtV-kbRcOAp5nd7tFmQ&s=10',
      'likes': 8,
      'quantity': 1,
      'selected': false,
      'liked': false,
    },
    {
      'name': 'Wireless Mouse',
      'category': 'ATK F1',
      'price': 250000,
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiVvT7ziq6PVids-hV75O0zhCI9Vuw2eIsiVThqpX03w&s=10',
      'likes': 5,
      'quantity': 1,
      'selected': false,
      'liked': false,
    },
  ];


  int selectedBottomIndex = 0;


  Timer? longPressTimer;
  bool isLongPress = false;

  OverlayEntry? _selectedBannerEntry;
  Timer? _selectedBannerTimer;

  String formatRupiah(int number) {
    return 'Rp ${number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match.group(1)}.',
    )}';
  }

  int get totalItems {
    int total = 0;
    for (var product in products) {
      total += product['quantity'] as int;
    }
    return total;
  }

  int get totalPrice {
    int total = 0;
    for (var product in products) {
      total += (product['price'] as int) * (product['quantity'] as int);
    }
    return total;
  }

  void increaseQuantity(int index) {
    setState(() {
      products[index]['quantity']++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (products[index]['quantity'] > 1) {
        products[index]['quantity']--;
      }
    });
  }

  void selectProduct(int index) {
    setState(() {
      products[index]['selected'] = !(products[index]['selected'] ?? false);
    });
  }

  void doubleTapProduct(int index) {
    setState(() {
      if (products[index]['liked'] == true) {
        products[index]['likes']--;
        products[index]['liked'] = false;
      } else {
        products[index]['likes']++;
        products[index]['liked'] = true;
      }
    });
  }

  void longPressProduct(int index, BuildContext bannerContext) {
    final product = products[index];
    _showSelectedBanner(bannerContext, product['name'] as String);
  }

  void _showSelectedBanner(BuildContext context, String productName) {
    _removeSelectedBanner();

    final overlay = Overlay.of(context);

    _selectedBannerEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Produk dipilih!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$productName telah dipilih.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _removeSelectedBanner,
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_selectedBannerEntry!);
    _selectedBannerTimer = Timer(const Duration(seconds: 3), () {
      _removeSelectedBanner();
    });
  }

  void _removeSelectedBanner() {
    _selectedBannerTimer?.cancel();
    _selectedBannerTimer = null;
    _selectedBannerEntry?.remove();
    _selectedBannerEntry = null;
  }

  void changeBottomNavigation(int index) {
    setState(() {
      selectedBottomIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.shopping_cart),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Cart',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Belanja lebih mudah setiap hari',
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(index, products[index]);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Barang',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          '$totalItems barang',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatRupiah(totalPrice),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Checkout $totalItems barang '
                                'dengan total '
                                '${formatRupiah(totalPrice)}',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 13,
                      ),
                    ),
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedBottomIndex,
        onTap: changeBottomNavigation,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Kategori',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (totalItems > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$totalItems',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: const Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(int index, Map<String, dynamic> product) {
    final bool selected = product['selected'] ?? false;
    final bool liked = product['liked'] ?? false;

    return Listener(
      onPointerDown: (event) {
        isLongPress = false;
        longPressTimer?.cancel();
        longPressTimer = Timer(const Duration(milliseconds: 700), () {
          isLongPress = true;
          longPressProduct(index, context);
        });
      },
      onPointerUp: (event) {
        longPressTimer?.cancel();
      },
      onPointerCancel: (event) {
        longPressTimer?.cancel();
      },

      child: GestureDetector(
        behavior: HitTestBehavior.opaque,

        onTap: () {
          if (!isLongPress) {
            selectProduct(index);
          }
          isLongPress = false;
        },

        onDoubleTap: () {
          isLongPress = false;
          doubleTapProduct(index);
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? Colors.blue : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product['image'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_outlined,
                        size: 45,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      product['category'],
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      formatRupiah(product['price']),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          liked ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: liked ? Colors.red : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${product['likes']}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        decreaseQuantity(index);
                      },
                      icon: const Icon(
                        Icons.remove,
                        size: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 35,
                    child: Center(
                      child: Text(
                        '${product['quantity']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        increaseQuantity(index);
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    longPressTimer?.cancel();
    _selectedBannerTimer?.cancel();
    _selectedBannerEntry?.remove();
    super.dispose();
  }
}