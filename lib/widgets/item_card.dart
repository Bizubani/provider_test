import 'package:flutter/cupertino.dart';
import 'package:provider_test/main.dart';
import 'package:provider_test/painter/graph_painter.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final Function increment;
  final Function decrement;
  final CartItem item;

  final List<IconData> icons = [
    Icons.agriculture_rounded,
    Icons.airplay_rounded,
    Icons.airport_shuttle_rounded,
    Icons.all_inbox_rounded,
    Icons.add_road_rounded
  ];
  ItemCard(
      {required this.increment, required this.decrement, required this.item});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Size rectSize = Size(size.width * 0.25, size.height * 0.12);
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FittedBox(
          child: SizedBox(
            width: rectSize.width,
            height: rectSize.height,
            child: Stack(
              children: [
                CustomPaint(
                  size: rectSize,
                  painter: GraphPainter(item.quantity),
                ),
                Card(
                  elevation: 2.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListTile(
                        leading: Icon(icons[item.id % icons.length]),
                        title: Text(
                          "${item.name}",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        subtitle: Text(
                          "${item.id}",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => increment(context, item.id, 1)),
                          Text(
                            " ${item.quantity}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => decrement(context, item.id, -1)),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
