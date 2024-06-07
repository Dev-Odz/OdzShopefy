import 'package:fakestore_app/modules/home/data/cart_data.dart';
import 'package:fakestore_app/modules/home/model/products_model.dart';
import 'package:fakestore_app/modules/home/services/products_services.dart';
import 'package:flutter/material.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({
    super.key,
    required this.productId,
  });

  final int? productId;

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

ProductServices productServices = ProductServices();
CartLocalStorage _cartLocalStorage = CartLocalStorage();
Map productItem = {};
int quantity = 0;

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  getProduct() async {
    var productdetail =
        await productServices.getProduct(productId: widget.productId);

    setState(() {
      productItem.addAll(productdetail);
    });
  }

  // INITIALIZE
  @override
  void initState() {
    super.initState();
    productItem.clear();
    quantity = 0;
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // *CONTENT
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                productItem.isEmpty
                    ? Container()
                    : Container(
                        padding: const EdgeInsets.fromLTRB(172, 79, 172, 79),
                        width: MediaQuery.of(context).size.width,
                        height: 800,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 540,
                              child: SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      productItem['image'],
                                      height: 300,
                                    ),
                                    const SizedBox(
                                      height: 64,
                                    ),
                                    Text(
                                      productItem['description'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Text(
                                        productItem['title'],
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(18.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '\$${productItem['price'].toString()}',
                                                    style: const TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 17, 47, 90),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 14,
                                                  ),
                                                  const Text(
                                                    'Quantity',
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              quantity =
                                                                  quantity + 1;
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.add,
                                                          ),
                                                        ),
                                                        Text(
                                                          '$quantity',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 22,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              quantity =
                                                                  quantity - 1;

                                                              if (quantity <
                                                                  0) {
                                                                quantity = 0;
                                                              }
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.remove,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(18.0),
                                                          child: SizedBox(
                                                            width: 250,
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  const ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStatePropertyAll(
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          17,
                                                                          47,
                                                                          90),
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                await _cartLocalStorage
                                                                    .setData([
                                                                  {
                                                                    "id": widget
                                                                        .productId,
                                                                    "quantity":
                                                                        quantity,
                                                                  }
                                                                ]);

                                                                var data =
                                                                    await _cartLocalStorage
                                                                        .getData();

                                                                print(data);
                                                              },
                                                              child: const Text(
                                                                'Add to Cart',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
      ),
    );
  }
}
