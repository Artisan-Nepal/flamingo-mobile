import 'package:flamingo/data/remote/rest/api_client.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/remote/product_remote.dart';

class ProductRemoteImpl implements ProductRemote {
  // ignore: unused_field
  final ApiClient _apiClient;

  ProductRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<Product>> getProductList() async {
    return [
      Product(
          imageurl: [
            'https://plus.unsplash.com/premium_photo-1692809752577-72da691a28ae?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
          ],
          price: '12.99',
          id: '1',
          brand: 'Gucci',
          name: 'Shirt',
          size: ['XL', 'L'],
          discount: '30% off',
          description: 'Product 1 description'),
      Product(
        imageurl: [
          'https://plus.unsplash.com/premium_photo-1692809752577-72da691a28ae?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          'https://plus.unsplash.com/premium_photo-1698846880893-fe6432d51597?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyfHx8ZW58MHx8fHx8'
        ],
        id: '11',
        price: '12.99',
        brand: 'Gucci',
        name: 'Shirt22',
        size: ['XL', 'L'],
        description: 'Product 1 description',
      ),
      Product(
        imageurl: [
          'https://plus.unsplash.com/premium_photo-1692809752577-72da691a28ae?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          'https://plus.unsplash.com/premium_photo-1698846877123-6677c975db78?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzfHx8ZW58MHx8fHx8'
        ],
        price: '12.99',
        id: '2',
        brand: 'Nike',
        name: 'Sneakers',
        size: ['US 10', 'US 11'],
        description: 'Product 2 description',
      ),
      Product(
        imageurl: [
          'https://plus.unsplash.com/premium_photo-1692809752577-72da691a28ae?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          'https://images.unsplash.com/photo-1699355484587-b5018a07b73e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1fHx8ZW58MHx8fHx8',
          'https://images.unsplash.com/photo-1699356426894-6cf94459b827?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw4fHx8ZW58MHx8fHx8'
        ],
        price: '12.99',
        id: '3',
        brand: 'Adidas',
        name: 'Shorts',
        size: ['M', 'L'],
        description: 'Product 3 description',
      ),
      Product(
        price: '12.99',
        imageurl: [
          'https://plus.unsplash.com/premium_photo-1692809752577-72da691a28ae?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        ],
        id: '4',
        brand: 'Puma',
        name: 'Hat',
        size: ['One Size'],
        description: 'Product 4 description',
      ),
      Product(
        price: '12.99',
        imageurl: [
          'https://plus.unsplash.com/premium_photo-1692809752577-72da691a28ae?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        ],
        id: '5',
        brand: 'Levi\'s',
        name: 'Jeans',
        size: ['30x32', '32x32'],
        description: 'Product 5 description',
      ),
      Product(
        price: '12.99',
        imageurl: [
          'https://plus.unsplash.com/premium_photo-1692809752577-72da691a28ae?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        ],
        id: '6',
        brand: 'Vans',
        name: 'Socks',
        size: ['M', 'L'],
        description: 'Product 6 description',
      ),
      Product(
        price: '12.99',
        imageurl: [
          'https://plus.unsplash.com/premium_photo-1692809752577-72da691a28ae?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        ],
        id: '7',
        brand: 'Converse',
        name: 'T-shirt',
        size: ['S', 'M', 'L'],
        description: 'Product 7 description',
      ),
      Product(
        price: '12.99',
        imageurl: [
          'https://plus.unsplash.com/premium_photo-1692809752577-72da691a28ae?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        ],
        id: '8',
        brand: 'Fila',
        name: 'Hoodie',
        size: ['S', 'M', 'L', 'XL'],
        description: 'Product 8 description',
      ),
      Product(
          price: '12.99',
          imageurl: [
            'https://plus.unsplash.com/premium_photo-1692809752577-72da691a28ae?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
          ],
          id: '9',
          brand: 'Gucci',
          name: 'Belt',
          size: ['M', 'L', 'XL'],
          description: 'Product 9 description',
          discount: '25% off'),
      Product(
        price: '12.99',
        imageurl: [
          'https://plus.unsplash.com/premium_photo-1692809752577-72da691a28ae?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        ],
        id: '10',
        brand: 'Calvin Klein',
        name: 'Underwear',
        size: ['S', 'M', 'L'],
        description: 'Product 10 description',
      ),
    ];
  }
}
