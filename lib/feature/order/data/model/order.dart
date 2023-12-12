import 'package:flamingo/feature/address/data/model/address.dart';
import 'package:flamingo/feature/order/data/model/order_status.dart';
import 'package:flamingo/feature/order/data/model/payment_method.dart';
import 'package:flamingo/feature/order/data/model/shipping_method.dart';
import 'package:flamingo/feature/product/data/model/product.dart';

class Order {
  final String id;
  final String customerId;
  final int orderTotal;
  final Address shippingAddress;
  final Address billingAddress;
  final PaymentMethod paymentMethod;
  final ShippingMethod shippingMethod;
  List<OrderItem> orderItems;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.customerId,
    required this.shippingAddress,
    required this.billingAddress,
    required this.paymentMethod,
    required this.shippingMethod,
    required this.orderTotal,
    required this.orderItems,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        customerId: json['customerId'],
        orderTotal: json['orderTotal'],
        shippingAddress: Address.fromJson(json['shippingAddress']),
        billingAddress: Address.fromJson(json['billingAddress']),
        paymentMethod: PaymentMethod.fromJson(json['paymentMethod']),
        shippingMethod: ShippingMethod.fromJson(json['shippingMethod']),
        orderItems: OrderItem.fromJsonList(json['orderItems']),
        createdAt: DateTime.parse(json['createdAt']),
      );

  static List<Order> fromJsonList(dynamic json) => List<Order>.from(
        json.map(
          (data) => Order.fromJson(data),
        ),
      );
}

class OrderItem {
  final String id;
  final String orderId;
  final int quantity;
  final int price;
  final OrderItemProduct product;
  final ProductVariant productVariant;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.product,
    required this.productVariant,
    required this.orderId,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json['id'],
        quantity: json['quantity'],
        orderId: json['orderId'],
        price: json['price'],
        product: OrderItemProduct.fromJson(json['productVariant']['product']),
        productVariant: ProductVariant.fromJson(json['productVariant']),
      );

  static List<OrderItem> fromJsonList(dynamic json) => List<OrderItem>.from(
        json.map(
          (data) => OrderItem.fromJson(data),
        ),
      );
}

class OrderItemProduct {
  final String id;
  final String title;
  final String body;
  final OrderStatus status;

  OrderItemProduct({
    required this.id,
    required this.title,
    required this.body,
    required this.status,
  });

  factory OrderItemProduct.fromJson(Map<String, dynamic> json) =>
      OrderItemProduct(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        status: OrderStatus.fromJson(json['status']),
      );
}
