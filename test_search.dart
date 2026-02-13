import 'package:books_discovery_app/core/network/dio_client.dart';
import 'package:books_discovery_app/feature/home/data/datasources/book_remote_datasource.dart';

void main() async {
  print('Testing Google Books API...');

  final dioClient = DioClient();
  final dataSource = BookRemoteDataSourceImpl(dioClient: dioClient);

  try {
    print('Searching for "author"...');
    final books = await dataSource.searchBooks('author');
    print('Success! Found ${books.length} books');

    if (books.isNotEmpty) {
      print('First book: ${books.first.title}');
      print('Authors: ${books.first.authors}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
