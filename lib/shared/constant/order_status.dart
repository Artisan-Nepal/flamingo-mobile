import 'package:flamingo/feature/order/data/model/order_status.dart';

// TODO
final orderStatusLookup = [
  OrderStatus(
    id: '',
    name: 'Pending',
    description: '',
    sequenceNumber: 0,
    code: 'PENDING',
  ),
  OrderStatus(
    id: '',
    name: 'Processing',
    description: '',
    sequenceNumber: 1,
    code: 'PROCESSING',
  ),
  OrderStatus(
    id: '',
    name: 'Out for delivery',
    description: '',
    sequenceNumber: 2,
    code: 'OUT_FOR_DELIVERY',
  ),
  OrderStatus(
    id: '',
    name: 'Delivered',
    description: '',
    sequenceNumber: 3,
    code: 'DELIVERED',
  ),
  OrderStatus(
    id: '',
    name: 'Cancelled',
    description: '',
    sequenceNumber: -1,
    code: 'CANCELLED',
  ),
];
