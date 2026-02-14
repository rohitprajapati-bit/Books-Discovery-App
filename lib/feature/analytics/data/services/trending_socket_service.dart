import 'dart:async';
import 'dart:math';

class TrendingBook {
  final String title;
  final String author;
  final int trendScore;
  final double salesChange; // Percentage change in sales

  TrendingBook({
    required this.title,
    required this.author,
    required this.trendScore,
    required this.salesChange,
  });
}

abstract class TrendingSocketService {
  Stream<List<TrendingBook>> get trendingStream;
  void dispose();
}

class TrendingSocketServiceImpl implements TrendingSocketService {
  final _controller = StreamController<List<TrendingBook>>.broadcast();
  Timer? _timer;

  final List<String> _mockTitles = [
    'The Midnight Library',
    'Atomic Habits',
    'Project Hail Mary',
    'Lessons in Chemistry',
    'Demon Copperhead',
    'Verity',
    'It Ends with Us',
    'Sea of Tranquility',
  ];

  final List<String> _mockAuthors = [
    'Matt Haig',
    'James Clear',
    'Andy Weir',
    'Bonnie Garmus',
    'Barbara Kingsolver',
    'Colleen Hoover',
    'Colleen Hoover',
    'Emily St. John Mandel',
  ];

  TrendingSocketServiceImpl() {
    _startMockStream();
  }

  void _startMockStream() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final random = Random();
      final List<TrendingBook> trending = [];

      // Select 3-5 random books
      final count = 3 + random.nextInt(3);
      final indices = List.generate(_mockTitles.length, (index) => index);
      indices.shuffle();

      for (int i = 0; i < count; i++) {
        final idx = indices[i];
        trending.add(
          TrendingBook(
            title: _mockTitles[idx],
            author: _mockAuthors[idx],
            trendScore: 80 + random.nextInt(20),
            // Random sales change between -5.0% and +15.0%
            salesChange: (random.nextDouble() * 20) - 5,
          ),
        );
      }

      // Sort by trend score
      trending.sort((a, b) => b.trendScore.compareTo(a.trendScore));

      if (!_controller.isClosed) {
        _controller.add(trending);
      }
    });
  }

  @override
  Stream<List<TrendingBook>> get trendingStream => _controller.stream;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
