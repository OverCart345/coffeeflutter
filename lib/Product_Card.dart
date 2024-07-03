import 'package:flutter/material.dart';
import 'product.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.network(
              widget.product.imageUrl,
              fit: BoxFit.cover,
              height: 100,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.product.name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 35,
              alignment: Alignment.center,
              child: quantity > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(0),
                              backgroundColor: const Color.fromARGB(255, 152, 199, 221),
                            ),
                            onPressed: () {
                              setState(() {
                                if (quantity > 0) quantity--;
                              });
                            },
                            child: Icon(Icons.remove, color: Colors.white, size: 16),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 152, 199, 221),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          child: Text(
                            quantity.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(0),
                              backgroundColor: const Color.fromARGB(255, 152, 199, 221),
                            ),
                            onPressed: () {
                              setState(() {
                                if (quantity < 10) quantity++;
                              });
                            },
                            child: Icon(Icons.add, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          quantity = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 152, 199, 221),
                        minimumSize: Size(130, 35),
                      ),
                      child: Text(widget.product.price,
                        style: TextStyle(color: Colors.white),),
                    ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
