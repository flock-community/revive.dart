import 'package:freezed_annotation/freezed_annotation.dart';

part 'async_exception.freezed.dart';

@freezed
class AsyncException with _$AsyncException {
  factory AsyncException.notLoaded() = NotLoaded;
  factory AsyncException.noConnection() = NoConnection;
}
