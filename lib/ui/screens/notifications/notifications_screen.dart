import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/notifications_provider.dart';
import 'package:news_app/ui/widgets/empty_state.dart';

import 'widgets/notification_tile.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus semua notifikasi?'),
        content: const Text('Tindakan ini tidak bisa dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok == true) ref.read(notificationsProvider.notifier).clearAll();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final items = ref.watch(notificationsProvider);
    final notifier = ref.read(notificationsProvider.notifier);

    final unread = items.where((n) => !n.isRead).toList();
    final read = items.where((n) => n.isRead).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Text('Notifikasi', style: theme.textTheme.headlineMedium),
          ),
          // Baris chip, ukuran sama dengan CategoryChips di Beranda
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                ActionChip(
                  label: const Text('Tandai semua dibaca'),
                  onPressed: unread.isEmpty ? null : notifier.markAllAsRead,
                ),
                const SizedBox(width: 8),
                ActionChip(
                  label: const Text('Hapus semua'),
                  onPressed:
                      items.isEmpty ? null : () => _confirmClear(context, ref),
                ),
              ],
            ),
          ),
          const _ReadingReminderCard(),
          if (items.isEmpty)
            const SizedBox(
              height: 320,
              child: EmptyState(
                icon: Icons.notifications_none_rounded,
                title: 'Belum ada notifikasi',
                message: 'Berita penting dan rekomendasi akan muncul di sini',
              ),
            ),
          if (unread.isNotEmpty) ...[
            _SectionTitle('Baru (${unread.length})'),
            for (final n in unread)
              NotificationTile(
                notification: n,
                onTap: () => notifier.markAsRead(n.id),
              ),
          ],
          if (read.isNotEmpty) ...[
            const _SectionTitle('Riwayat'),
            for (final n in read)
              NotificationTile(notification: n, onTap: () {}),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(text, style: theme.textTheme.titleLarge),
    );
  }
}

/// Reading Reminders (UI saja, belum menjadwalkan notifikasi sungguhan).
class _ReadingReminderCard extends StatefulWidget {
  const _ReadingReminderCard();

  @override
  State<_ReadingReminderCard> createState() => _ReadingReminderCardState();
}

class _ReadingReminderCardState extends State<_ReadingReminderCard> {
  bool _enabled = true;
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 0);

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(28),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        leading: Icon(Icons.alarm_rounded, color: cs.primary),
        title: const Text('Pengingat membaca'),
        subtitle: Text('Setiap hari, ${_time.format(context)}'),
        onTap: _pickTime,
        trailing: Switch(
          value: _enabled,
          onChanged: (v) => setState(() => _enabled = v),
        ),
      ),
    );
  }
}