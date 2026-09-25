import '../../../../core/utils/result.dart';
import '../entities/language.dart';
import '../repositories/language_repository.dart';

class ListLanguagesUseCase {
  ListLanguagesUseCase(this._r);
  final LanguageRepository _r;
  Future<Result<List<Language>>> call({bool refresh = true}) =>
      _r.listAll(refresh: refresh);
}
