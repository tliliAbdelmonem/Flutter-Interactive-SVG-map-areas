import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:map_areas/src/constants.dart';
import 'package:map_areas/src/models/area-model.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

/// A widget that builds map areas using a list of `AreaModel` objects.
/// Each area is rendered as a clickable region with a custom path.
Widget mapAreasBuilder(BuildContext context, List<AreaModel> areaItems,
    void Function(AreaModel) onTap, AreaModel? selectedArea) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height - 300,
    child: Stack(
      alignment: Alignment.topLeft,
      children: [
        // Iterates through each area in the list and builds a corresponding widget.
        ...areaItems.map((e) {
          return ClipPath(
            clipper: Clipper(svgPath: e.path),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                CustomPaint(
                    painter: PathPainterFill(e)), // Fills the area with color.
                CustomPaint(
                    painter: PathPainterStroke(
                        e, 1.0)), // Draws a stroke around the area's path.
                // Highlights the area if it is selected and adds a gesture detector to handle taps.
                Container(
                  color: selectedArea?.id == e.id
                      ? HexColor(AREA_SELECTED_COLOR).withOpacity(1)
                      : Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      onTap(e);
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    ),
  );
}

/// CustomPainter class to paint the stroke of an area's path.
class PathPainterStroke extends CustomPainter {
  final AreaModel _area;
  final double strokeWidth;
  PathPainterStroke(this._area, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    // Parses the SVG path string into a Path object.
    Path path = parseSvgPath(_area.path);

    // Applies a scale transformation to the path.
    final Matrix4 matrix4 = Matrix4.identity();
    matrix4.scale(0.5);

    // Draws the stroke of the path on the canvas.
    canvas.drawPath(
        path.transform(matrix4.storage).shift(const Offset(-90, 2)),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth);
  }

  // Indicates that the painter should repaint whenever a new stroke is created.
  @override
  bool shouldRepaint(PathPainterStroke oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(PathPainterStroke oldDelegate) => true;
}

/// CustomPainter class to paint the fill of an area's path.
class PathPainterFill extends CustomPainter {
  final AreaModel _area;

  // Constructor initializes the area model.
  PathPainterFill(this._area);

  @override
  void paint(Canvas canvas, Size size) {
    // Parses the SVG path string into a Path object.
    Path path = parseSvgPath(_area.path);

    // Applies a scale transformation to the path.
    final Matrix4 matrix4 = Matrix4.identity();
    matrix4.scale(0.5);

    // Draws the fill of the path on the canvas.
    canvas.drawPath(
        path.transform(matrix4.storage).shift(const Offset(-90, 2)),
        Paint()
          ..style = PaintingStyle.fill
          ..color = _area.color);
  }

// Indicates that the painter should repaint whenever a new fill is created.
  @override
  bool shouldRepaint(PathPainterFill oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(PathPainterFill oldDelegate) => true;
}

/// CustomClipper class to clip an area according to an SVG path.
class Clipper extends CustomClipper<Path> {
  const Clipper({required this.svgPath});

  final String svgPath;

  @override
  Path getClip(Size size) {
    // Parses the SVG path string into a Path object.
    var path = parseSvgPath(svgPath);

    // Applies a scale transformation to the path.
    final Matrix4 matrix4 = Matrix4.identity();
    matrix4.scale(0.5);
    return path.transform(matrix4.storage).shift(const Offset(-90, 2));
  }

// Indicates that the clipper should reclip whenever a new clip path is created.
  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
