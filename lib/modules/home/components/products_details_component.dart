import 'package:flutter/material.dart';

class ProductsDetailsComponent extends StatefulWidget {
  const ProductsDetailsComponent({
    super.key,
    this.title,
    this.imgSrc,
    this.price,
    this.mainWindowConstraints,
    this.changeImageSize,
  });

  final String? title;
  final String? imgSrc;
  final String? price;
  final BoxConstraints? mainWindowConstraints;
  final Function? changeImageSize;

  @override
  State<ProductsDetailsComponent> createState() =>
      _ProductsDetailsComponentState();
}

class _ProductsDetailsComponentState extends State<ProductsDetailsComponent> {
  @override
  Widget build(BuildContext context) {
    var mobileSize = widget.mainWindowConstraints!.maxWidth < 1030 &&
        widget.mainWindowConstraints!.maxWidth > 700;
    var mobileSizeSmall = widget.mainWindowConstraints!.maxWidth < 700;

    return SizedBox(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                widget.imgSrc!,
                height: mobileSize
                    ? 200
                    : mobileSizeSmall
                        ? MediaQuery.of(context).size.width * .20
                        : 150,
                width: 200,
              ),
              Flexible(
                child: Text(
                  widget.title ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: mobileSize
                        ? 24
                        : mobileSizeSmall
                            ? MediaQuery.of(context).size.width * .02
                            : 16,
                  ),
                ),
              ),
              Text(
                '\$${widget.price}',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * .02,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
