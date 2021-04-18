import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_example/model/route.dart';
import 'package:revive_example/model/todo.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
class Event with _$Event {
  factory Event.onAppStarted() = AppStarted;
  factory Event.onAppReloaded() = AppReloaded;
  factory Event.onInboxOpened() = InboxOpened;
  factory Event.onTodayOpened() = TodayOpened;
  factory Event.onTodoCompleted(Todo todo) = TodoCompleted;
  factory Event.onCreateTodoFormSubmitted({required CreateTodoModal modal}) = CreateTodoFormSubmitted;
  factory Event.onUpdateTodoFormSubmitted({required UpdateTodoModal modal}) = UpdateTodoFormSubmitted;

  factory Event.fromJson(Map<String, Object> json) => _$EventFromJson(json);
}
