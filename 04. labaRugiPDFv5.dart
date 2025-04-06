import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart'; // Import intl package untuk formatting

/// Fungsi utama untuk membuat laporan laba rugi dalam format PDF
/// [parLogoUrl] adalah URL logo perusahaan
Future<void> labaRugiPDFv5(
  String parLogoUrl, // URL logo perusahaan
  String parReportDate, // Tanggal laporan
  String parServiceRevenue41, // Pendapatan Jasa (akun 41)
  String parSparepartSales42, // Penjualan Sparepart (akun 42)
  String parOtherRevenues49, // Pendapatan Lain-lain (akun 49)
  String parSalaryWages61, // Gaji dan Upah (akun 61)
  String parCostOfSales62, // Harga Pokok Penjualan (akun 62)
  String parOtherExpenses69, // Biaya Lain-lain (akun 69)
  String parTotalRevenue, // Total Pendapatan
  String parTotalExpenses, // Total Beban
  String parProfitLoss, // Laba/Rugi
  String parUserName, // Nama User
) async {
  final pdf = pw
      .Document(); // Membuat dokumen PDF kosong // final maksudnya nilainya final/kada baubah lagi
  final imageLogo =
      await networkImage(parLogoUrl); // Mengambil logo dari internet

  // pemisah ribuan pakai koma, kada pakai desimal, tanpa simbol AUD
  // kalau mau pake titik, coba fikir kan...
  final formatMataUangAUD = NumberFormat('#,##0', 'en_AU');

  // Menambahkan halaman baru ke dokumen PDF
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4, // Ukuran A4
      margin: const pw.EdgeInsets.all(32), // Margin 32 di semua sisi
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment:
              pw.CrossAxisAlignment.start, // Semua item sejajar dari kiri
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Image(imageLogo,
                    width: 50, height: 50), // Lugu perusahaan kisahnya
                pw.SizedBox(width: 10),
                pw.Text(
                  'Romy Oz, Ltd', // Nama perusahaan
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 10),

            // Judul laporan
            pw.Center(
              child: pw.Text(
                'Daily Profit and Loss Statement', // Nama laporan
                style: pw.TextStyle(fontSize: 18),
              ),
            ),
            pw.SizedBox(height: 10),

            // Tanggal laporan
            pw.Center(
              child: pw.Text(
                'Period: $parReportDate', // Periode laporan
                style: pw.TextStyle(fontSize: 14),
              ),
            ),
            pw.SizedBox(height: 20),

            // Header tabel
            pw.Table(
              border: pw.TableBorder.all(), // Tabel dengan semua border
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              columnWidths: {
                0: pw.FlexColumnWidth(
                    2), // Kolom pertama (deskripsi) lebih lebar
                1: pw.FlexColumnWidth(1), // Kolom kedua (nilai) lebih kecil
              },
              children: [
                // _buatHeaderTabel(), // Header putih
                _buatHeaderTabelGrey(), // Header Grey Abu abu
                // ini isi tabel nya bos, angka pake format currency AUD pake koma
                _buatBarisRomyOz(
                    '41. Service Revenue',
                    formatMataUangAUD
                        .format(double.parse(parServiceRevenue41))),
                // formatMataUangAUD.format(2500.0); // maka hasilnya : '2,500'

                _buatBarisRomyOz(
                    '42. Sparepart Sales',
                    formatMataUangAUD
                        .format(double.parse(parSparepartSales42))),
                _buatBarisRomyOz('49. Other Revenues',
                    formatMataUangAUD.format(double.parse(parOtherRevenues49))),
                // --------------------
                _barisKusung(), // Baris kusung
                _buatBarisRomyOz('Total Revenue',
                    formatMataUangAUD.format(double.parse(parTotalRevenue)),
                    isBold: true),
                _barisKusung(),
                // --------------------
                _buatBarisRomyOz('61. Salary and Wages',
                    formatMataUangAUD.format(double.parse(parSalaryWages61))),
                _buatBarisRomyOz('62. Cost of Sales',
                    formatMataUangAUD.format(double.parse(parCostOfSales62))),
                _buatBarisRomyOz('69. Other Expenses',
                    formatMataUangAUD.format(double.parse(parOtherExpenses69))),

                _barisKusung(), // Baris kusung
                _buatBarisRomyOz('Total Expenses',
                    formatMataUangAUD.format(double.parse(parTotalExpenses)),
                    isBold: true),
                _barisKusung(),

                _buatBarisRomyOz('Profit/Loss',
                    formatMataUangAUD.format(double.parse(parProfitLoss))),
              ],
            ),

            pw.SizedBox(height: 30), // ini spasi

            // Bagian tanda tangan
            pw.Text(
              'Reported on: $parReportDate in Canberra', // Tanggal dan lokasi laporan
              style: pw.TextStyle(fontSize: 12),
            ),
            pw.SizedBox(height: 20), // Jarak besar untuk tanda tangan

            pw.Text(
              'Reported by:', // Siapa yang membuat laporan
              style: pw.TextStyle(fontSize: 12),
            ),
            pw.SizedBox(height: 60),

            pw.Text(
              parUserName, // Nama user
              style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic),
            ),
          ],
        );
      },
    ),
  );

  // Cetak dokumen ke printer atau simpan sebagai file PDF
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

/// Membuat baris kosong di dalam tabel
pw.TableRow _barisKusung() {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(''), // Kolom kosong
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(''), // Kolom kosong
      ),
    ],
  );
}

/// Membuat header tabel laporan
pw.TableRow _buatHeaderTabel() {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(
          'Description',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center, // centre
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(
          'Amount (AUD)',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center, // centre
        ),
      ),
    ],
  );
}

/// Membuat header tabel laporan
pw.TableRow _buatHeaderTabelGrey() {
  return pw.TableRow(
    children: [
      pw.Container(
        color: PdfColors.grey300, // <-- ini background light gray
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(
          'Description',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
        ),
      ),
      pw.Container(
        color: PdfColors.grey300, // <-- ini background light gray
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(
          'Amount (AUD)',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
        ),
      ),
    ],
  );
}

/// Membuat baris isi laporan
/// [description] adalah keterangan, [amount] adalah nilainya
/// [isBold] true bila handak menebalkan teks (default false)
pw.TableRow _buatBarisRomyOz(String description, String amount,
    {bool isBold = false}) {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(
          description,
          style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Align(
          alignment: pw.Alignment.centerRight, // Angka rata kanan
          child: pw.Text(
            amount,
            style: pw.TextStyle(
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
          ),
        ),
      ),
    ],
  );
}
