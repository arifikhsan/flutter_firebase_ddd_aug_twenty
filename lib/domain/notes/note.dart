import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_aug/domain/auth/value_objects.dart';
import 'package:flutter_firebase_ddd_aug/domain/core/value_failures.dart';
import 'package:flutter_firebase_ddd_aug/domain/notes/todo_item.dart';
import 'package:flutter_firebase_ddd_aug/domain/notes/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';

part 'note.freezed.dart';

@freezed
abstract class Note implements _$Note {
  const Note._();

  const factory Note({
    @required UniqueId id,
    @required NoteBody body,
    @required NoteColor color,
    @required ListThree<TodoItem> todos,
  }) = _Note;

  factory Note.empty() => Note(
        id: UniqueId(),
        body: NoteBody(''),
        color: NoteColor(NoteColor.predefinedColors.first),
        todos: ListThree(emptyList()),
      );

  Option<ValueFailure<dynamic>> get failureOption {
    return body.failureOrUnit
        .andThen(todos.failureOrUnit)
        .andThen(
          todos
              .getOrCrash()
              .map((todoItem) => todoItem.failureOption)
              .filter((o) => o.isSome())
              .getOrElse(0, (_) => none())
              .fold(() => right(unit), (f) => left(f)),
        )
        .fold(
          (failure) => some(failure),
          (_) => none(),
        );
  }
}
