import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<void> shareFiles(List<String> paths) async {
    await Share.shareXFiles(paths.map(XFile.new).toList());
  }

  Future<void> shareZip(String path) async {
    await Share.shareXFiles([XFile(path)]);
  }
}
