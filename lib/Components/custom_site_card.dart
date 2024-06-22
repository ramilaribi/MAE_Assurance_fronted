import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSiteCardView extends StatefulWidget {
  final String name;
  final String img;

  CustomSiteCardView({Key? key, required this.name,required this.img}) : super(key: key);

  @override
  State<CustomSiteCardView> createState() => _CustomSiteCardViewState();
}

class _CustomSiteCardViewState extends State<CustomSiteCardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160, // Maintained compact height
      width: 200,
      decoration: BoxDecoration(
      color: const Color(0xFFF7F9F4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.asset(
              "assets/images/${widget.img}",
              height: 150, // Increased image height for better visibility
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10, top: 2, right: 4, bottom: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment
                    .spaceAround, // Ensures even distribution of space
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
