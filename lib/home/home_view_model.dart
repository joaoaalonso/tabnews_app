import 'package:tabnews_app/shared/repositories/tag_repository.dart';
import 'package:tabnews_app/shared/models/tag.dart';

class HomeViewModel {
  final _tagRepository = TagRepository();

  Future<List<Tag>> getAvailableTags() {
    return _tagRepository.getAvailableTags();
  }
}
