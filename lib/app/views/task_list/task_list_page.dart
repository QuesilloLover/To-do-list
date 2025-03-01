import 'package:flutter/material.dart';
import 'package:lista_tarea/app/models/task.dart';
import 'package:lista_tarea/app/repository/task_repository.dart';
import 'package:lista_tarea/app/views/components/shape.dart';
import 'package:lista_tarea/app/views/components/title.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  int count = 0;
  final taskList = <Task>[];
  final TaskRepository taskRepository = TaskRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const _Header(),
                Expanded(
                    child: FutureBuilder<List<Task>>(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(), //este es el puntito xdd
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No hay tareas. Agrega una! :D'),
                      );
                    }
                    return _TaskList(
                      snapshot.data!,
                      onTaskDoneChange: (task) {
                        task.done = !task.done;
                        taskRepository.saveTasks(snapshot.data!);
                        setState(() {});
                      },
                    );
                  },
                  future: taskRepository.getTasks(),
                ))
              ],
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showNewTaskModal(context),
          child: Icon(Icons.add),
        ));
  }

  void _showNewTaskModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => _NewTaskModal(
              onTaskCreated: (Task task) {
                taskRepository.addTask(task);
                setState(() {});
              },
            ));
  }
}

class _NewTaskModal extends StatelessWidget {
  _NewTaskModal({required this.onTaskCreated});

  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final void Function(Task task) onTaskCreated;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 23),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              H1('Nueva Tarea'),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Título de la tarea',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _subtitleController,
                decoration: InputDecoration(
                  hintText: 'Subtítulo',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Descripción de la tarea',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isNotEmpty) {
                    final task = Task(
                      _titleController.text,
                      subtitle: _subtitleController.text,
                      description: _descriptionController.text,
                    );
                    onTaskCreated(task);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: unused_element
class _TaskItem extends StatelessWidget {
  const _TaskItem(this.task, {this.onTap});

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, 
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    task.done
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    task.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (task.subtitle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    task.subtitle,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
              if (task.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    task.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: unused_element
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Color(0xFF40B7AD),
          height: 291,
          width: double.infinity,
        ),
        Shape(),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                'assets/img/tasks_list.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(
                height: 20,
              ),
              H1(
                'Completa tus tareas',
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList(this.taskList, {required this.onTaskDoneChange});

  final List<Task> taskList;
  final void Function(Task task) onTaskDoneChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const H1('Tareas'),
          Expanded(
            child: ListView.separated(
                itemBuilder: (_, index) => _TaskItem(
                      taskList[index],
                      onTap: () => onTaskDoneChange(taskList[index]),
                    ),
                separatorBuilder: (_, __) => const SizedBox(
                      height: 16,
                    ),
                itemCount: taskList.length),
          ),
        ],
      ),
    );
  }
}
