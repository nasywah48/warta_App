/// Kategori berita yang didukung oleh endpoint top-headlines NewsAPI.
enum NewsCategory { // singkatan dari enumeration
// tipe data khusus yang digunakan untuk menyimpan sekumpulan nilai konstanta yang tetap dan sudah ditentukan sebelumnya
  general('Utama'),
  business('Bisnis'),
  technology('Teknologi'),
  science('Sains'),
  health('Kesehatan'),
  sports('Olahraga'),
  entertainment('Hiburan');

  const NewsCategory(this.label);

  /// Label yang ditampilkan di UI.
  final String label;

  /// Nilai yang dikirim ke API.
  String get apiValue => name; // apiValue adalah sebuah properti (variabel) di dalam NewsCategory yang bertugas sebagai penerjemah bahasa Flutter ke bahasa API.
}
