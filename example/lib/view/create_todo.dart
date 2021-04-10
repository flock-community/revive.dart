import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/route.dart';
import 'package:revive_example/service/events.dart';
import 'package:revive_example/service/route_state.dart';
import 'package:revive_example/widgets.dart';

abstract class CreateTodoContext implements EventStream, RouteState {}

class CreateTodo extends HookWidget {
  CreateTodo(this.$, this.form, {Key? key}) : super(key: key);

  final CreateTodoContext $;
  final CreateTodoForm form;

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    var todoField = useTextEditingController();
    const sizedBoxSpace = SizedBox(height: 24);

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Todo"),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              sizedBoxSpace,
              TextFormField(
                controller: todoField,
                decoration: InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.description),
                  hintText: 'Add a task',
                  labelText: 'Todo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              sizedBoxSpace,
              Center(
                // padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: form.submitting
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            $.events.add(Event.onTodoFormSubmitted(
                              description: todoField.value.text,
                              modal: form,
                            ));
                          }
                        },
                  child: form.submitting ? Text('Loading...') : Text('SUBMIT', style: TextStyle(fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
