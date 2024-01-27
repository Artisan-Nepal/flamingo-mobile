import 'package:flamingo/feature/order/data/model/order_status.dart';

// TODO
final orderStatusLookup = [
  OrderStatus(
    id: '',
    name: 'Pending',
    description: 'Your order has been received and is awaiting processing.',
    sequenceNumber: 0,
    code: 'PENDING',
  ),
  OrderStatus(
    id: '',
    name: 'Processing',
    description: 'Your order is currently being prepared for shipment.',
    sequenceNumber: 1,
    code: 'PROCESSING',
  ),
  OrderStatus(
    id: '',
    name: 'Out for delivery',
    description:
        'Your order is out for delivery and will be at your doorstep soon.',
    sequenceNumber: 2,
    code: 'OUT_FOR_DELIVERY',
  ),
  OrderStatus(
    id: '',
    name: 'Delivered',
    description: 'Your order has been successfully delivered.',
    sequenceNumber: 3,
    code: 'DELIVERED',
  ),
  OrderStatus(
    id: '',
    name: 'Cancelled',
    description: 'Your order has been cancelled.',
    sequenceNumber: -1,
    code: 'CANCELLED',
  ),
];

OrderStatus getNextOrderStatus(int sequenceNumber) {
  return orderStatusLookup.firstWhere(
    (element) => element.sequenceNumber == sequenceNumber + 1,
  );
}
