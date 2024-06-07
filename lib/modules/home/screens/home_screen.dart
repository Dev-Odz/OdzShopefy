import 'package:fakestore_app/modules/home/model/products_model.dart';
import 'package:fakestore_app/modules/home/screens/item_detail_screen.dart';
import 'package:fakestore_app/modules/home/services/products_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

ProductServices productServices = ProductServices();
List<ProductsModel>? productsList;

class _HomeScreenState extends State<HomeScreen> {
  Widget getAllProductsWidgets({String? title, String? imgSrc, String? price}) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                imgSrc!,
                height: 200,
                width: 200,
              ),
              Flexible(
                child: Text(
                  title ?? '',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(price ?? ''),
            ],
          ),
        ),
      ),
    );
  }

  getAllProducts() async {
    var products = await productServices.getAllProducts();

    setState(() {
      productsList = products
          .map((product) => ProductsModel(
                title: product['title'],
                category: product['category'],
                description: product['description'],
                id: product['id'],
                image: product['image'],
                price: product['price'].toDouble(),
                rating: Rating(
                  count: product['rating']['count'],
                  rate: product['rating']['rate'].toDouble(),
                ),
              ))
          .toList();
    });
  }

  // INITIALIZE
  @override
  void initState() {
    super.initState();
    productsList = [];
    getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // *CONTENT
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/hero.jpg',
                  width: double.maxFinite,
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      'products'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Order it to your beloved ones',
                    ),
                  ],
                ),
              ),
              productsList!.isEmpty
                  ? Container()
                  : SizedBox(
                      height: double.maxFinite,
                      child: GridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 16,
                        padding: const EdgeInsets.all(8),
                        childAspectRatio: (1 / .85),
                        children: productsList!
                            .map(
                              (product) => SizedBox(
                                height: 200,
                                child: InkWell(
                                  onTap: () {
                                    // Navigate to next page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ItemDetailScreen(
                                              productId: product.id);
                                        },
                                      ),
                                    );
                                  },
                                  child: getAllProductsWidgets(
                                    imgSrc: product.image,
                                    title: product.title,
                                    price: product.price.toString(),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    )
            ],
          ),
        ),

        // *TOPBAR
        Positioned(
          top: 0,
          child: Container(
            color: const Color.fromARGB(255, 232, 231, 231),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/ODzShopefy_Logo.png',
                    height: 50,
                  ),
                  const SizedBox(
                    child: Row(
                      children: [
                        Text('Discovery'),
                        Icon(Icons.arrow_downward_sharp),
                        SizedBox(
                          width: 37,
                        ),
                        Text('About'),
                        SizedBox(
                          width: 37,
                        ),
                        Text('Contact Us'),
                        SizedBox(
                          width: 37,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Image.asset('assets/images/Profile.png'),
                        ),
                        const SizedBox(
                          width: 37,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Image.asset('assets/images/Cart.png'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
