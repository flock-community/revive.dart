import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive/service/clock.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/route.dart';
import 'package:revive_example/model/todo_form.dart';
import 'package:revive_example/service/events.dart';
import 'package:revive_example/service/navigator.dart';
import 'package:revive_example/util/extensions.dart';
import 'package:revive_example/widgets.dart';

abstract class CreateTodoContext implements TodoFormViewContext, EventStream {}

class CreateTodoPage extends StatelessWidget {
  CreateTodoPage(this.$, this.modal, {Key? key}) : super(key: key);

  final CreateTodoContext $;
  final CreateTodoModal modal;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Todo")),
      body: TodoFormView(
        $,
        form: modal.form,
        onSubmitted: (form) {
          $.events.add(Event.onCreateTodoFormSubmitted(
            modal: modal.copyWith(form: form),
          ));
        },
      ),
    );
  }
}

abstract class UpdateTodoPageContext implements TodoFormViewContext, EventStream {}

class UpdateTodoPage extends StatelessWidget {
  UpdateTodoPage(this.$, this.modal, {Key? key}) : super(key: key);

  final UpdateTodoPageContext $;
  final UpdateTodoModal modal;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Todo")),
      body: TodoFormView(
        $,
        form: modal.form,
        onSubmitted: (form) {
          $.events.add(Event.onUpdateTodoFormSubmitted(
            modal: modal.copyWith(form: form),
          ));
        },
      ),
    );
  }
}

abstract class TodoFormViewContext implements WithClock, WithNavigator {}

class TodoFormView extends HookWidget {
  TodoFormView(
    this.$, {
    Key? key,
    required this.form,
    required this.onSubmitted,
  }) : super(key: key);

  final TodoFormViewContext $;
  final void Function(TodoForm) onSubmitted;
  final _formKey = GlobalKey<FormState>();
  final TodoForm form;

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);
    final localForm = useState<TodoForm>(form);
    final focusNode = useFocusNode();

    return Form(
      key: _formKey,
      child: Scrollbar(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            sizedBoxSpace,
            TextFormField(
              initialValue: form.description,
              decoration: InputDecoration(
                filled: true,
                icon: const Icon(Icons.description),
                hintText: 'Add a task',
                labelText: 'Description',
              ),
              onChanged: (description) {
                localForm.value = localForm.value.copyWith(description: description);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            sizedBoxSpace,
            if (localForm.value.dueDate != null)
              DateTimePicker(
                focusNode: focusNode,
                decoration: InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.event),
                  labelText: 'Due date',
                  hintText: 'No due date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () async {
                      localForm.value = localForm.value.copyWith(dueDate: null);
                      // hack because of https://github.com/flutter/flutter/issues/39376
                      await $.clock.sleep(1.milliseconds);
                      Navigator.pop(context);
                    },
                  ),
                ),
                initialValue: localForm.value.dueDate?.toIso8601String(),
                type: DateTimePickerType.date,
                dateMask: 'dd MMMM yyyy',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                initialDate: localForm.value.dueDate,
                onChanged: (date) {
                  localForm.value = localForm.value.copyWith(dueDate: DateTime.parse(date));
                },
              )
            else
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.event),
                  labelText: 'Add due date',
                ),
                onTap: () async {
                  localForm.value = localForm.value.copyWith(dueDate: $.clock.now());
                  focusNode.requestFocus();
                },
              ),
            sizedBoxSpace,
            Center(
              child: ElevatedButton(
                onPressed: form.submitting
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) onSubmitted(localForm.value);
                      },
                child: form.submitting ? Text('Loading...') : Text('SUBMIT', style: TextStyle(fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
