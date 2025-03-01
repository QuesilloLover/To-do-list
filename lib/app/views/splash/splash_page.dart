import 'package:flutter/material.dart';
import 'package:lista_tarea/app/views/components/shape.dart';
import 'package:lista_tarea/app/views/components/title.dart';
import 'package:lista_tarea/app/views/task_list/task_list_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold is a layout for a whole page
      body: Column(
        children: [
          Row(
            children: const [
              Shape()
            ],
          ),

          const SizedBox(
            height: 79,
          ),

          Image.asset(
            'assets/img/onboarding-image.png',
            width: 180,
            height: 168,
          ),

          const SizedBox(
            height: 99,
          ),

          H1('Lista de tareas /ᐠ ˵> ⩊ <˵マ'),
          
          const SizedBox(
            height: 21,
          ),

          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return TaskListPage();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'La mejor forma para que no se te olvide nada es anotarlo. Guardar tus tareas y ve completando poco a poco para aumentar tu productividad.',
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 20),
          
          GestureDetector(
            onTap: () async {
              final url = Uri.parse('https://docs.flutter.dev/tos');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
            child: const Text(
              'Términos y condiciones',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}
