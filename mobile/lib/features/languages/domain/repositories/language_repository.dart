import '../../../../core/utils/result.dart';
import '../entities/language.dart';

abstract class LanguageRepository {
  Future<Result<List<Language>>> listAll({bool refresh = true});
  Future<List<Language>> readLocal();
}
