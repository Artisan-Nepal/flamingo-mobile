// import 'package:flamingo/feature/product/data/model/product_color.dart';
// import 'package:flamingo/shared/shared.dart';
// import 'package:flamingo/widget/text/text.dart';
// import 'package:flamingo/widget/widget.dart';
// import 'package:flutter/material.dart';

// class AdditionalScreen extends StatefulWidget {
//   final Product product;

//   AdditionalScreen({
//     required this.product,
//   });

//   @override
//   _AdditionalScreenState createState() => _AdditionalScreenState();
// }

// class _AdditionalScreenState extends State<AdditionalScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             TextWidget(
//               widget.product.name,
//               style: TextStyle(fontSize: 24, color: AppColors.black),
//             ),
//             TextWidget(
//               widget.product.price,
//               style: TextStyle(fontSize: 18, color: AppColors.black),
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product ID
//             TextWidget(
//               'Product ID: ${widget.product.id}',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             VerticalSpaceWidget(height: 5),

//             // Product Description
//             TextWidget(
//               'Product Description: ${widget.product.description}',
//               style: TextStyle(
//                 fontSize: 16,
//               ),
//             ),
//             VerticalSpaceWidget(height: 10),

//             // Sizes Available
//             TextWidget(
//               'Sizes Available: ${widget.product.size.join(', ')}',
//               style: TextStyle(
//                 fontSize: 16,
//               ),
//             ),
//             VerticalSpaceWidget(height: 10),

//             // Colors (assuming product colors are a list of strings)
//             TextWidget(
//               'Colors: ',
//               style: TextStyle(
//                 fontSize: 16,
//               ),
//             ),
//             VerticalSpaceWidget(height: 10),

//             // Care and other information
//             TextWidget(
//               'Care and Other Information: ',
//               style: TextStyle(
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
