import 'package:fan_poll/app/models/models.dart';
import 'package:fan_poll/app/modules/home/controllers/home_controller.dart';
import 'package:fan_poll/app/modules/home/views/home_view.dart';
import 'package:fan_poll/app/utills/appServices.dart';
import 'package:fan_poll/app/utills/color.dart';
import 'package:fan_poll/app/utills/localStorageService.dart';
import 'package:fan_poll/app/utills/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SharedPollView extends StatefulWidget {
  final int pollId;
  final bool isGuest;

  const SharedPollView({
    super.key,
    required this.pollId,
    required this.isGuest,
  });

  @override
  State<SharedPollView> createState() => _SharedPollViewState();
}

class _SharedPollViewState extends State<SharedPollView> {
  late Future<PollModel?> _pollFuture;
  final ApiService api = ApiService();
  late PollModel? _currentPoll;

  @override
  void initState() {
    super.initState();
    _pollFuture = _fetchPoll();
  }

  Future<PollModel?> _fetchPoll() async {
    try {
      final token = await LocalStorageService.getString('token');
      print('SharedPoll: Fetching poll ID: ${widget.pollId}');
      print('SharedPoll: User token exists: ${token != null && token.isNotEmpty}');
      
      PollModel? poll;
      if (token == null || token.isEmpty) {
        poll = await api.getPollById(widget.pollId);
      } else {
        poll = await api.getPollById(widget.pollId, token: token);
      }
      
      print('SharedPoll: Fetched poll: $poll');
      if (poll != null) {
        print('SharedPoll: Poll title: ${poll.title}');
        print('SharedPoll: Poll options count: ${poll.options?.length ?? 0}');
      }
      return poll;
    } catch (e) {
      print('SharedPoll Error fetching poll: $e');
      return null;
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('You need to login to perform this action.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.toNamed('/login');
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.toNamed('/register');
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WhiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.WhiteColor,
        surfaceTintColor: AppColor.WhiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Shared Poll'),
      ),
      body: FutureBuilder<PollModel?>(
        future: _pollFuture,
        builder: (context, snapshot) {
          print('SharedPoll: FutureBuilder state: ${snapshot.connectionState}');
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading poll...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            print('SharedPoll: Error: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error loading poll'),
                  const SizedBox(height: 8),
                  Text(snapshot.error.toString(), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.data == null) {
            print('SharedPoll: Poll data is null');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Poll not found or has been deleted'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          final poll = snapshot.data!;
          _currentPoll = poll;
          final isPollActive = !(poll.isExpired ?? true);

          return ListView(
            padding: const EdgeInsets.only(bottom: 50),
            children: [
              PollCard(
                creator: poll.creator ?? Creator(),
                poll_id: poll.id ?? 0,
                title: poll.title ?? '',
                description: poll.description ?? '',
                hashtags: poll.hashtags ?? '',
                websiteUrl: poll.url ?? '',
                imageUrl: poll.imageUrl ?? '',
                options: poll.options
                        ?.map((e) => PollOption(
                              label: String.fromCharCode(65 + ((e.order ?? 1) - 1)),
                              text: e.text ?? '',
                              percentage: (e.percentage ?? 0).toDouble(),
                              is_voted: e.isVoted ?? false,
                              vote_count: e.voteCount ?? 0,
                              id: e.id ?? 0,
                            ))
                        .toList() ??
                    [],
                date: Utils.formatDate(poll.createdAt ?? ''),
                daysLeft: Utils.calculateDaysLeft(poll.expiresAt ?? ''),
                likes: poll.totalVotes ?? 0,
                comments: poll.commentsCount ?? 0,
                isPast: !isPollActive,
                can_vote: isPollActive && !widget.isGuest && (poll.canVote ?? true),
                is_own_poll: poll.isOwnPoll ?? false,
                isLiked: poll.isLiked ?? false,
                onLike: () {
                  if (widget.isGuest) {
                    _showLoginDialog();
                    return;
                  }
                  if (!Get.isRegistered<HomeController>()) {
                    Get.put<HomeController>(HomeController());
                  }
                  final homeController = Get.find<HomeController>();
                  homeController.likePoll(poll.id, isPastPoll: !isPollActive);
                  setState(() {
                    if (_currentPoll != null) {
                      _currentPoll!.isLiked = !(_currentPoll!.isLiked ?? false);
                      _currentPoll!.likesCount = (_currentPoll!.likesCount ?? 0) + 
                          ((_currentPoll!.isLiked ?? false) ? 1 : -1);
                    }
                  });
                },
                likesCount: poll.likesCount ?? 0,
                onComment: widget.isGuest ? () {
                  _showLoginDialog();
                } : null,
                onFollow: widget.isGuest ? () {
                  _showLoginDialog();
                } : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
