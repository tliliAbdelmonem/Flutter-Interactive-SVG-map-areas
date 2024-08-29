import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:map_areas/src/constants.dart';
import 'package:map_areas/src/data/map.dart';
import 'package:map_areas/src/models/area-model.dart';
import 'package:map_areas/src/widgets/map-areas-builder.dart';
import 'package:xml/xml.dart';

/// A widget that displays map areas as interactive regions.
class MapAreasWidget extends StatefulWidget {
  const MapAreasWidget({super.key});

  @override
  State<MapAreasWidget> createState() => _MapAreasWidgetState();
}

class _MapAreasWidgetState extends State<MapAreasWidget>
    with TickerProviderStateMixin {
  // Parses the XML document containing map area data.
  final document = XmlDocument.parse(mapAreas);

  // Stores the currently selected area.
  AreaModel? selectedArea;

  /// Converts SVG paths in the XML document to a list of `AreaModel` objects.
  List<AreaModel> svgPthsToList(XmlDocument document) {
    final paths = document.findAllElements('path');
    // Maps each <path> element in the XML to an AreaModel object.
    List<AreaModel> areas = paths
        .map((element) => AreaModel(
              color: HexColor(
                  AREA_DEFAULT_COLOR), // Sets a default color for the area.
              id: element.getAttribute('id').toString(), // Sets the ID.
              name: element.getAttribute('name').toString(), // Sets the name.
              path: element
                  .getAttribute('d')
                  .toString(), // Sets the SVG path data.
            ))
        .toList();

    return areas; // Returns the list of area models.
  }

  /// Handles the event when an area is pressed, updating the selected area.
  void onAreaPressed(AreaModel area) {
    setState(() {
      selectedArea = area; // Updates the state with the new selected area.
    });
  }

  @override
  Widget build(BuildContext context) {
    // Converts the XML document into a list of area models.
    List<AreaModel> areas = svgPthsToList(document);

    // Builds the widget tree, displaying the map areas.
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          mapAreasBuilder(context, areas, onAreaPressed, selectedArea),
          const Spacer(),
          Container(
            margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10),
            //   color: Colors.white,
            //   boxShadow: const [
            //     BoxShadow(color: Colors.black12, spreadRadius: 1),
            //   ],
            // ),
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  selectedArea?.name ?? "",
                  style: TextStyle(
                      color: HexColor("#FFAB40"),
                      fontWeight: FontWeight.w900,
                      fontSize: 24.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
