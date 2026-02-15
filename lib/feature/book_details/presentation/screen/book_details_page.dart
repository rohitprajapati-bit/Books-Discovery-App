import 'package:auto_route/auto_route.dart';
import 'package:books_discovery_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:books_discovery_app/feature/home/domain/entities/book.dart';
import '../bloc/book_details_bloc.dart';
import '../bloc/book_details_event.dart';
import 'package:books_discovery_app/utils/responsive_layout.dart';
import '../layouts/mobile_book_details_screen.dart';
import '../layouts/tablet_book_details_screen.dart';
import '../layouts/desktop_book_details_screen.dart';

@RoutePage()
class BookDetailsPage extends StatelessWidget {
  final Book book;

  const BookDetailsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    // Obtain userId from AuthBloc
    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.id : '';

    // Add the load event to the global bloc when entering this page
    context.read<BookDetailsBloc>().add(LoadBookDetailsEvent(book, userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ResponsiveLayout(
        mobileBody: MobileBookDetailsScreen(book: book),
        tabletBody: TabletBookDetailsScreen(book: book),
        desktopBody: DesktopBookDetailsScreen(book: book),
      ),
    );
  }
}
