import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key, this.senderType = 'customer'});

  final String senderType;

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final _supabase = Supabase.instance.client;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  Map<String, dynamic>? _ticket;
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Init ─────────────────────────────────────────────────────────────────────

  Future<void> _init() async {
    await _fetchOpenTicket();
    if (_ticket != null) {
      await _loadMessages();
      _subscribeToMessages();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _fetchOpenTicket() async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final data = await _supabase
          .from('chat_tickets')
          .select()
          .eq('user_id', userId)
          .not('status', 'in', '("closed","resolved")')
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      if (mounted) setState(() => _ticket = data);
    } catch (e) {
      debugPrint('❌ fetchOpenTicket error: $e');
    }
  }

  Future<void> _loadMessages() async {
    if (_ticket == null) return;
    try {
      final data = await _supabase
          .from('chat_messages')
          .select()
          .eq('ticket_id', _ticket!['id'])
          .order('created_at', ascending: true);
      if (mounted) setState(() => _messages = List<Map<String, dynamic>>.from(data));
      _scrollToBottom();
    } catch (_) {}
  }

  void _subscribeToMessages() {
    if (_ticket == null) return;
    _channel?.unsubscribe();
    _channel = _supabase
        .channel('support_chat_${_ticket!['id']}')
        // ── New messages ────────────────────────────────────────────────────
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'ticket_id',
            value: _ticket!['id'],
          ),
          callback: (payload) {
            final msg = Map<String, dynamic>.from(payload.newRecord);
            if (!_messages.any((m) => m['id'] == msg['id'])) {
              setState(() => _messages.add(msg));
              _scrollToBottom();
            }
          },
        )
        // ── Ticket status changes (e.g. closed, claimed) ────────────────────
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'chat_tickets',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: _ticket!['id'],
          ),
          callback: (payload) {
            if (!mounted) return;
            setState(() {
              _ticket = {
                ..._ticket!,
                ...Map<String, dynamic>.from(payload.newRecord),
              };
            });
          },
        )
        .subscribe();
  }

  // ── Send message ──────────────────────────────────────────────────────────────

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isClosed) return;

    final gp = context.read<GlobalProvider>();
    final userId = _supabase.auth.currentUser!.id;
    final userName = (gp.user?['name'] as String?) ?? 'User';
    final userEmail = _supabase.auth.currentUser?.email ?? '';
    final userAvatar = gp.user?['avatar_url'] as String?;

    // ── 1. Show message instantly ─────────────────────────────────────────────
    _controller.clear();
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final tempMsg = <String, dynamic>{
      'id': tempId,
      'ticket_id': _ticket?['id'] ?? '',
      'sender_id': userId,
      'sender_type': widget.senderType,
      'sender_name': userName,
      'content': text,
      'created_at': DateTime.now().toUtc().toIso8601String(),
      'read_at': null,
    };
    setState(() => _messages.add(tempMsg));
    _scrollToBottom();

    // ── 2. Persist in background ──────────────────────────────────────────────
    try {
      if (_ticket == null) {
        final ticketData = await _supabase
            .from('chat_tickets')
            .insert({
              'user_id': userId,
              'user_name': userName,
              'user_email': userEmail,
              'user_avatar': userAvatar,
              'user_type': widget.senderType,
              'subject': 'Support Request',
              'status': 'open',
            })
            .select()
            .single();
        if (!mounted) return;
        setState(() {
          _ticket = ticketData;
          final idx = _messages.indexWhere((m) => m['id'] == tempId);
          if (idx != -1) {
            _messages[idx] = {..._messages[idx], 'ticket_id': ticketData['id']};
          }
        });
        _subscribeToMessages();
      }

      final msgData = await _supabase
          .from('chat_messages')
          .insert({
            'ticket_id': _ticket!['id'],
            'sender_id': userId,
            'sender_type': widget.senderType,
            'sender_name': userName,
            'content': text,
          })
          .select()
          .single();

      if (!mounted) return;
      setState(() {
        final idx = _messages.indexWhere((m) => m['id'] == tempId);
        if (idx != -1) _messages[idx] = Map<String, dynamic>.from(msgData);
      });

      final newUnread = ((_ticket!['unread_count'] ?? 0) as int) + 1;
      _supabase.from('chat_tickets').update({
        'last_message': text,
        'last_message_at': DateTime.now().toIso8601String(),
        'unread_count': newUnread,
      }).eq('id', _ticket!['id']);

      if (mounted) {
        setState(() {
          _ticket!['unread_count'] = newUnread;
          _ticket!['last_message'] = text;
        });
      }
    } catch (e) {
      debugPrint('❌ support chat send error: $e');
      if (!mounted) return;
      setState(() => _messages.removeWhere((m) => m['id'] == tempId));
      _controller.text = text;
    }
  }

  // ── Start new conversation ────────────────────────────────────────────────────

  Future<void> _startNewConversation() async {
    setState(() {
      _ticket = null;
      _messages = [];
      _isLoading = false;
    });
    _channel?.unsubscribe();
    _channel = null;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool get _isClosed {
    final status = _ticket?['status'] as String?;
    return status == 'closed' || status == 'resolved';
  }

  bool get _isClaimed => _ticket?['claimed_by'] != null;

  String get _currentUserId => _supabase.auth.currentUser!.id;

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: _buildAppBar(colors, l10),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ── Closed banner ──────────────────────────────────────────
                if (_isClosed) _ClosedBanner(onNewChat: _startNewConversation),

                // ── Messages ───────────────────────────────────────────────
                Expanded(
                  child: _ticket == null && _messages.isEmpty
                      ? _EmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: _messages.length,
                          itemBuilder: (context, i) {
                            final msg = _messages[i];
                            final isMe = msg['sender_id'] == _currentUserId;
                            final showName = !isMe &&
                                (i == 0 ||
                                    _messages[i - 1]['sender_id'] !=
                                        msg['sender_id']);
                            final showTime = i == _messages.length - 1 ||
                                _isDifferentMinute(
                                  msg['created_at'],
                                  _messages[i + 1]['created_at'],
                                );
                            return _MessageBubble(
                              message: msg,
                              isMe: isMe,
                              showSenderName: showName,
                              showTime: showTime,
                            );
                          },
                        ),
                ),

                // ── Input bar ──────────────────────────────────────────────
                _InputBar(
                  controller: _controller,
                  isDisabled: _isClosed,
                  onSend: _send,
                ),
              ],
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(ColorScheme colors, AppLocalizations l10) {
    return AppBar(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
        color: colors.onSurface,
      ),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.support_agent_rounded,
              size: 20,
              color: colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10.supportChat,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              if (_ticket != null)
                Text(
                  _isClosed
                      ? l10.ticketClosed
                      : _isClaimed
                      ? l10.agentConnected
                      : l10.waitingForAgent,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: _isClosed
                        ? colors.error
                        : _isClaimed
                        ? Colors.green
                        : colors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: colors.outline),
      ),
    );
  }

  bool _isDifferentMinute(String? a, String? b) {
    if (a == null || b == null) return true;
    final ta = DateTime.tryParse(a);
    final tb = DateTime.tryParse(b);
    if (ta == null || tb == null) return true;
    return ta.minute != tb.minute || ta.hour != tb.hour;
  }
}

// ── Message bubble ────────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.showSenderName,
    required this.showTime,
  });

  final Map<String, dynamic> message;
  final bool isMe;
  final bool showSenderName;
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final content = message['content'] as String? ?? '';
    final createdAt = message['created_at'] as String?;
    final time = createdAt != null
        ? DateFormat('h:mm a').format(DateTime.parse(createdAt).toLocal())
        : '';

    return Padding(
      padding: EdgeInsets.only(
        top: showSenderName ? 10 : 3,
        bottom: showTime ? 2 : 0,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showSenderName && !isMe)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 3),
              child: Text(
                message['sender_name'] as String? ?? 'Support',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                ),
              ),
            ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(right: 6, bottom: 2),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.support_agent_rounded,
                    size: 15,
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ],
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? colors.primary : colors.surfaceContainer,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                  ),
                  child: Text(
                    content,
                    style: TextStyle(
                      fontSize: 14.5,
                      color: isMe ? colors.onPrimary : colors.onSurface,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (showTime)
            Padding(
              padding: EdgeInsets.only(
                top: 4,
                left: isMe ? 0 : 40,
                right: isMe ? 4 : 0,
                bottom: 6,
              ),
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 11,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Input bar ─────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.isDisabled,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isDisabled;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 1, thickness: 1, color: colors.outline),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 120),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: controller,
                      enabled: !isDisabled,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontSize: 14.5,
                        color: colors.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: isDisabled
                            ? 'This conversation is closed'
                            : 'Type a message…',
                        hintStyle: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 14.5,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: isDisabled ? null : onSend,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isDisabled
                          ? colors.surfaceContainerHighest
                          : colors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                            Icons.send_rounded,
                            size: 20,
                            color: isDisabled
                                ? colors.onSurfaceVariant
                                : colors.onPrimary,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state (no ticket yet) ───────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.support_agent_rounded,
                size: 38,
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10.supportChatTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10.supportChatSubtitle,
              style: TextStyle(
                fontSize: 13.5,
                color: colors.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Closed banner ─────────────────────────────────────────────────────────────

class _ClosedBanner extends StatelessWidget {
  const _ClosedBanner({required this.onNewChat});
  final VoidCallback onNewChat;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      color: colors.errorContainer,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10.ticketClosedBanner,
              style: TextStyle(
                fontSize: 13,
                color: colors.onErrorContainer,
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onNewChat,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colors.error,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l10.newConversation,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colors.onError,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
