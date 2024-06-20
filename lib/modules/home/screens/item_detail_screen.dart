import 'package:fakestore_app/modules/home/data/cart_data.dart';
import 'package:fakestore_app/modules/home/services/products_services.dart';
import 'package:flutter/cupertino.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          var mobileSize =
              constraints.maxWidth < 1030 && constraints.maxWidth > 700;
          var mobileSizeSmall = constraints.maxWidth < 700;
          var tabletSize =
              constraints.maxWidth > 1030 && constraints.maxWidth < 1080;
          var laptopSize =
              constraints.maxWidth > 1080 && constraints.maxWidth < 1400;
          var desktopSize = constraints.maxWidth > 800;

          var currentWidthSize = MediaQuery.of(context).size.width;
          var currentHeightSize = MediaQuery.of(context).size.height;

          return Stack(
            children: [
              // *CONTENT
              ListView(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  productItem.isEmpty
                      ? Container()
                      : Container(
                          constraints:
                              BoxConstraints(maxHeight: currentHeightSize),
                          padding: mobileSizeSmall
                              ? const EdgeInsets.all(24)
                              : mobileSize
                                  ? const EdgeInsets.all(32)
                                  : EdgeInsets.fromLTRB(
                                      currentHeightSize * .1,
                                      currentHeightSize * .07,
                                      currentHeightSize * .1,
                                      currentHeightSize * .07),
                          width: MediaQuery.of(context).size.width,
                          height: mobileSizeSmall ? currentHeightSize : 800,
                          child: mobileSizeSmall
                              ? SizedBox(
                                  height: double.maxFinite,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      itemDetail(),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          child: addToCart(
                                              currentWidthSize:
                                                  currentWidthSize),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: itemDetail()),
                                    const SizedBox(
                                      width: 24,
                                    ),
                                    Expanded(
                                      child: addToCart(
                                          currentWidthSize: currentWidthSize),
                                    ),
                                  ],
                                ),
                        )
                ],
              ),

              // *TOPBAR
              Positioned(
                top: 0,
                child: mobileSizeSmall
                    ? navBarMobile(context, currentWidthSize)
                    : navBarDesktop(context, currentWidthSize),
              ),
            ],
          );
        },
      ),
    );
  }

  SizedBox addToCart({double? currentWidthSize}) {
    return SizedBox(
      height: double.maxFinite,
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
          currentWidthSize! < 500
              ? addToCartDetail(currentWidthSize: currentWidthSize)
              : Expanded(
                  child: addToCartDetail(currentWidthSize: currentWidthSize),
                ),
        ],
      ),
    );
  }

  SizedBox addToCartDetail({double? currentWidthSize}) {
    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${productItem['price'].toString()}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 17, 47, 90),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity = quantity + 1;
                          });
                        },
                        icon: const Icon(
                          Icons.add,
                        ),
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity = quantity - 1;

                            if (quantity < 0) {
                              quantity = 0;
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.remove,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: SizedBox(
                          child: ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(255, 17, 47, 90),
                              ),
                            ),
                            onPressed: () async {
                              await _cartLocalStorage.setData([
                                {
                                  "id": widget.productId,
                                  "quantity": quantity,
                                }
                              ]);

                              await _cartLocalStorage.getData();
                            },
                            child: const Text(
                              'Add to Cart',
                              style: TextStyle(color: Colors.white),
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
    );
  }

  SizedBox itemDetail({double? currentWidthSize}) {
    return SizedBox(
      width: 540,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(
            productItem['image'],
            height: 300,
          ),
          // const SizedBox(
          //   height: 64,
          // ),
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
    );
  }

  navBarMobile(BuildContext context, double currentWidthSize) {
    return Container(
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
            Text(currentWidthSize.toString()),
            Text(MediaQuery.of(context).size.height.toString()),
            const Icon(Icons.menu)
          ],
        ),
      ),
    );
  }

  navBarDesktop(BuildContext context, double currentWidthSize) {
    return Container(
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
            Text(currentWidthSize.toString()),
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
    );
  }
}
