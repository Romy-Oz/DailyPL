import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

Future<void> generateAndPreviewPDF() async {
  final pdf = pw.Document(); // Membuat dokumen PDF kusung
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4, // Menentukan ukuran halaman PDF menggunakan format A4
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start, // Menyusun semua elemen anak ke arah kiri (start) secara horizontal
          children: [
            // Judul laporan
            pw.Text(
              'Laporan Keuangan',
              style: pw.TextStyle(fontSize: 24),
            ),
            pw.SizedBox(height: 20), // Memberikan jarak vertikal (spasi) antar elemen

            pw.Text('Pendapatan Layanan: Rp 10.000.000'), // Membuat teks biasa untuk informasi pendapatan layanan
            pw.Text('Penjualan Sparepart: Rp 5.000.000'),
            pw.Text('Lain-lain: Rp 2.000.000'),
            pw.SizedBox(height: 20),
            pw.Text('Total Pendapatan: Rp 17.000.000'),
            pw.SizedBox(height: 20),
            pw.Text('Biaya Gaji: Rp 4.000.000'),
            pw.Text('HPP: Rp 3.000.000'),
            pw.Text('Biaya Lain-lain: Rp 1.000.000'),
            pw.SizedBox(height: 20),
            pw.Text('Total Biaya: Rp 8.000.000'),
            pw.SizedBox(height: 20),
            pw.Text(
              'Laba Bersih: Rp 9.000.000',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, // gasan gaya huruf tebal (bold) pada teks
              ),
            ),
          ],
        );
      },
    ),
  );

  // Romy-Oz menyimpan dokumen PDF yang sudah dibuat ke dalam format bytes
  final Uint8List pdfBytes = await pdf.save();

  // Menampilkan preview PDF
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdfBytes,
  );
}
