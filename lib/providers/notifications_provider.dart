import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/app_notification.dart';

class NotificationsNotifier extends Notifier<List<AppNotification>> {
  @override
  List<AppNotification> build() => _dummy;

  /// Mark as Read: satu notifikasi.
  void markAsRead(String id) {
    state = [
      for (final n in state) n.id == id ? n.copyWith(isRead: true) : n,
    ];
  }

  /// Mark as Read: semua sekaligus.
  void markAllAsRead() {
    state = [for (final n in state) n.copyWith(isRead: true)];
  }

  /// Clear All: hapus semua notifikasi.
  void clearAll() {
    state = const [];
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, List<AppNotification>>(
  NotificationsNotifier.new,
);

/// Jumlah notifikasi belum dibaca (untuk badge lonceng).
final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).where((n) => !n.isRead).length;
});

const _dummy = <AppNotification>[
  AppNotification(
    id: '1',
    type: NotificationType.breaking,
    title: 'Gempa M 6,1 guncang pesisir selatan Jawa',
    body: 'BMKG memastikan tidak ada potensi tsunami. Warga diminta tetap tenang.',
    timeLabel: '5 mnt yang lalu',
  ),
  AppNotification(
    id: '2',
    type: NotificationType.latest,
    title: 'Ekonomi: Rupiah menguat tipis di akhir pekan',
    body: 'Berita terbaru dari kategori favoritmu, Ekonomi.',
    timeLabel: '40 mnt yang lalu',
  ),
  AppNotification(
    id: '3',
    type: NotificationType.recommended,
    title: 'Mengapa investasi hijau jadi prioritas utama?',
    body: 'Dipilih berdasarkan minat bacamu pada topik lingkungan.',
    timeLabel: '2 jam yang lalu',
  ),
  AppNotification(
    id: '4',
    type: NotificationType.latest,
    title: 'Teknologi: Satelit baru Indonesia siap meluncur',
    body: 'Peluncuran dijadwalkan pekan depan.',
    timeLabel: 'Kemarin',
    isRead: true,
  ),
  AppNotification(
    id: '5',
    type: NotificationType.breaking,
    title: 'Kebijakan baru transportasi publik berlaku Senin',
    body: 'Tarif dan jam operasional disesuaikan di beberapa rute.',
    timeLabel: '2 hari lalu',
    isRead: true,
  ),
];